const fs = require('fs');
const path = require('path');

// Function to transform JS to Civet-like syntax
function transformToCivet(content) {
  let lines = content.split('\n');
  let result = [];
  let inClass = false;
  let inMethod = false;
  let inArrow = false;
  let braceCount = 0;

  for (let i = 0; i < lines.length; i++) {
    let line = lines[i];
    let trimmed = line.trim();

    if (trimmed.startsWith('class ') && trimmed.includes('extends')) {
      // Class declaration, remove leading 12 spaces
      result.push(line.substring(12).replace(/\s*{\s*$/, ''));
      inClass = true;
    } else if (inClass && trimmed === '{') {
      // Skip opening brace for class
      continue;
    } else if (inClass && trimmed.match(/^\s*[a-zA-Z_][a-zA-Z0-9_]*\s*\(\s*\)$/)) {
      // Method declaration, remove leading 4, add 2
      let methodLine = '  ' + line.substring(4).replace(/\s*\(\s*\)$/, '()');
      result.push(methodLine);
      inMethod = true;
      braceCount = 1;
      // Skip the next { line
      i++;
      if (i < lines.length && lines[i].trim() === '{') {
        // skip
      } else {
        i--; // if not, back
      }
    } else if (inClass && trimmed.match(/^\s*constructor\s*\(\s*\)$/)) {
      let consLine = '  ' + line.substring(4).replace(/\s*\(\s*\)$/, '()');
      result.push(consLine);
      inMethod = true;
      braceCount = 1;
      i++;
      if (i < lines.length && lines[i].trim() === '{') {
        // skip
      } else {
        i--;
      }
    } else if (inClass && trimmed === '}' && inMethod) {
      // End of method
      braceCount--;
      if (braceCount === 0) {
        inMethod = false;
      }
    } else if (inClass && trimmed === '}' && !inMethod) {
      // End of class
      inClass = false;
    } else if (inClass && inMethod) {
      // Inside method, adjust indent, remove leading 8, add 4
      result.push('    ' + line.substring(8));
    } else if (inClass && !inMethod && trimmed.match(/^\s*[a-zA-Z_]/) && !trimmed.includes('=')) {
      // Property, remove leading 4, add 2
      result.push('  ' + line.substring(4));
    } else if (trimmed.includes('=>') && trimmed.includes('{')) {
      // Arrow function, adjust indent
      let arrowLine = line.replace(/^\s{12}/, '      ').replace(/^\s{8}/, '    ').replace(/^\s{4}/, '  ').replace(/\s*{\s*$/, '');
      result.push(arrowLine);
      inArrow = true;
      braceCount = 1;
    } else if (inArrow) {
      if (trimmed === '}') {
        braceCount--;
        if (braceCount === 0) {
          inArrow = false;
        }
      } else if (trimmed.includes('{')) {
        braceCount++;
      }
      // Adjust indent
      let arrowBody = line.replace(/^\s{12}/, '        ').replace(/^\s{8}/, '      ').replace(/^\s{4}/, '    ');
      result.push(arrowBody);
    } else {
      result.push(line);
    }
  }

  return result.join('\n');
}

// Recursive function to get all .civet files
function getCivetFiles(dir) {
  let files = [];
  const items = fs.readdirSync(dir);
  for (const item of items) {
    const fullPath = path.join(dir, item);
    const stat = fs.statSync(fullPath);
    if (stat.isDirectory()) {
      files = files.concat(getCivetFiles(fullPath));
    } else if (item.endsWith('.civet')) {
      files.push(fullPath);
    }
  }
  return files;
}

const civetFiles = getCivetFiles('/Users/valeureux/dev/civet/phaser/civet_examples');

civetFiles.forEach(file => {
  const content = fs.readFileSync(file, 'utf8');
  const transformed = transformToCivet(content);
  fs.writeFileSync(file, transformed);
});

console.log('Transformation complete for', civetFiles.length, 'files');