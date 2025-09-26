#!/bin/bash
mkdir -p phaser_js_examples
while read -r category_url; do
    category=$(basename "$category_url")
    mkdir -p "phaser_js_examples/$category"
    echo "Processing category: $category"
    curl -s "$category_url" | grep -o 'href="https://phaser.io/examples-show/[0-9]*"' | sed 's/href="//' | sed 's/"$//' | sort | uniq > "phaser_js_examples/$category/examples.txt"
    while read -r example_url; do
        example_id=$(basename "$example_url")
        echo "Downloading $example_id from $category"
        curl -s "$example_url" | sed -n '/<pre><code class="language-javascript">/,/<\/code><\/pre>/p' | sed '1d;$d' > "phaser_js_examples/$category/$example_id.js"
    done < "phaser_js_examples/$category/examples.txt"
done < phaser_js_examples/example_urls.txt
