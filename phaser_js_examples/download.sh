#!/bin/bash
mkdir -p phaser_js_examples
if [ $# -eq 0 ]; then
    categories=$(cat phaser_js_examples/example_urls.txt)
else
    categories="$1"
fi
for category_url in $categories; do
    category=$(basename "$category_url")
    mkdir -p "phaser_js_examples/$category"
    echo "Processing category: $category"
    curl -s "$category_url" | grep -o 'href="https://phaser.io/examples-show/[0-9]*"' | sed 's/href="//' | sed 's/"$//' | sort | uniq > "phaser_js_examples/$category/examples.txt"
    while read -r example_url; do
        if [ -z "$example_url" ]; then continue; fi
        example_id=$(basename "$example_url")
        if [ -f "phaser_js_examples/$category/$example_id.js" ]; then
            echo "Skipping $example_id from $category (already exists)"
            continue
        fi
        echo "Downloading $example_id from $category"
        redirect_url=$(curl -s "$example_url" | grep -o "url='[^']*'" | sed "s/url='//" | sed "s/'$//")
        curl -s "$redirect_url" | sed -n '/<pre id="source-main.js" class="hidden">/,/<\/pre>/p' | sed 's/<pre id="source-main.js" class="hidden">//' | sed '$d' > "phaser_js_examples/$category/$example_id.js"
    done < "phaser_js_examples/$category/examples.txt"
done
