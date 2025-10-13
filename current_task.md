# Current Task: JS vs Civet Comparison Feature

## Goal
Implement a side-by-side comparison between original JavaScript code and its Civet translation in Phaser examples to showcase Civet's conciseness and readability.

## Implementation Plan
- **Scraping**: Extend `kopi_lib/scrap.rb` to download and store original JS alongside Civet.
- **UI**: Modify `bridgetown/src/_layouts/example.erb` to include tabs/buttons for JS/Civet views.
- **Data**: Update example front matter to include JS paths.
- **Testing**: Verify on sample examples like align-to.

## Example Layout
```html
<div class="code-tabs">
  <button onclick="showJS()">JS</button>
  <button onclick="showCivet()">Civet</button>
</div>
<pre id="js-code" style="display:none;"><code class="language-js">// JS code</code></pre>
<pre id="civet-code"><code class="language-js">// Civet code</code></pre>
```

## Benefits
- Highlights Civet advantages.
- Educational for developers.

## Status
- Planning phase.</content>
</xai:function_call">  
</xai:function_call name="read">
<parameter name="filePath">current_task.md