# Current Task: Integrate Shiki Syntax Highlighting in Bridgetown Layout

## Goal
Replace the current mixed Prism.js + custom Shiki implementation with unified Shiki syntax highlighting for both JavaScript and Civet code in the Bridgetown example layout.

## Current Issues
- Uses Prism.js for JS and custom Shiki with 1200+ line TextMate grammar for Civet
- Inconsistent highlighting approach
- Complex custom grammar may not handle all Civet syntax correctly

## Implementation Plan

### Step 1: Remove Existing Dependencies
**File**: `bridgetown/src/_layouts/example.erb`
- Remove Prism.js CSS: `<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism.min.css">`
- Remove Prism.js JS: `<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>`
- Remove Shiki script: `<script src="https://unpkg.com/shiki@0.14.1/dist/index.umd.js"></script>`

### Step 2: Update Dependencies
Replace with unified Shiki:
```html
<script src="https://cdn.jsdelivr.net/npm/shiki@0.14.7/dist/index.umd.js"></script>
```

### Step 3: Replace JavaScript Logic
Remove the entire custom `civetGrammar` object (1200+ lines) and replace the `DOMContentLoaded` event listener with:

```javascript
document.addEventListener('DOMContentLoaded', async () => {
    // Initialize Shiki highlighter
    const highlighter = await shiki.getHighlighter({
        theme: 'one-dark-pro',
        langs: ['javascript', 'coffee']
    });

    // Load and highlight JS code
    fetch('<%= data.js_path %>')
        .then(response => response.text())
        .then(code => {
            const highlighted = highlighter.codeToHtml(code, { lang: 'javascript' });
            document.getElementById('js-code').innerHTML = highlighted;
        })
        .catch(err => {
            document.getElementById('js-code').innerHTML = '<pre><code>Error loading code.</code></pre>';
            console.error(err);
        });

    // Highlight Civet code
    const civetElement = document.querySelector('#civet-code code');
    const civetCode = civetElement.textContent;
    const highlightedCivet = highlighter.codeToHtml(civetCode, { lang: 'coffee' });
    document.getElementById('civet-code').innerHTML = highlightedCivet;
});
```

### Step 4: Update HTML Structure
Ensure `<pre>` elements have Shiki classes:
```html
<pre id="js-code" class="shiki one-dark-pro"></pre>
<pre id="civet-code" class="shiki one-dark-pro"></pre>
```

## Benefits
- **Unified approach**: Same library (Shiki) for both languages
- **Proven implementation**: Matches Civet playground's approach
- **Simplified codebase**: Removes 1200+ lines of custom grammar
- **Better maintenance**: Uses standard Shiki languages instead of custom TextMate grammar

## Testing Steps
1. Build Bridgetown: `bundle exec bridgetown build`
2. Serve locally: `bundle exec bridgetown serve`
3. Test example pages for proper JS and Civet highlighting
4. Verify tab switching works correctly
5. Check mobile responsiveness

## Rollback Plan
If issues arise, revert to Prism.js for both languages using standard grammars.

## Status
- Ready for implementation</content>
</xai:function_call">  
</xai:function_call name="write">
<parameter name="filePath">current_task.md