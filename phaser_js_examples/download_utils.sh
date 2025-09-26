#!/bin/bash
mkdir -p phaser_js_examples/utils
echo "Processing utils subfolders"
# Extract subfolder URLs from utils page
curl -s "https://phaser.io/examples/v3.85.0/utils" | grep -o 'href="https://phaser.io/examples/v3.85.0/utils/[^"]*"' | sed 's/href="//' | sed 's/"$//' | grep -v '/utils$' | sort | uniq > phaser_js_examples/utils/subfolders.txt

while read -r subfolder_url; do
    subfolder=$(basename "$subfolder_url")
    mkdir -p "phaser_js_examples/utils/$subfolder"
    echo "Processing subfolder: $subfolder"
    # Extract example URLs from subfolder page
    curl -s "$subfolder_url" | grep -o 'href="https://phaser.io/examples-show/[0-9]*"' | sed 's/href="//' | sed 's/"$//' | sort | uniq > "phaser_js_examples/utils/$subfolder/examples.txt"
    while read -r example_url; do
        if [ -z "$example_url" ]; then continue; fi
        example_id=$(basename "$example_url")
        if [ -f "phaser_js_examples/utils/$subfolder/$example_id.js" ]; then
            echo "Skipping $example_id from phaser_js_examples/utils/$subfolder (already exists)"
            continue
        fi
        echo "Downloading $example_id from phaser_js_examples/utils/$subfolder"
        redirect_url=$(curl -s "$example_url" | grep -o "url='[^']*'" | sed "s/url='//" | sed "s/'$//")
        curl -s "$redirect_url" | sed -n '/<pre id="source-main.js" class="hidden">/,/<\/pre>/p' | sed 's/<pre id="source-main.js" class="hidden">//' | sed '$d' > "phaser_js_examples/utils/$subfolder/$example_id.js"
    done < "phaser_js_examples/utils/$subfolder/examples.txt"
done < phaser_js_examples/utils/subfolders.txt