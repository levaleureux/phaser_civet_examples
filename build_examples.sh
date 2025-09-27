#!/bin/bash

# Build script for Phaser examples

JEKYLL_DIR="jekyll"
CIVET_DIR="civet_examples"
BUILD_DIR="$JEKYLL_DIR/js/builded_examples"
EXAMPLES_DIR="$JEKYLL_DIR/_examples"
DATA_DIR="$JEKYLL_DIR/_data"

# Create build directories
mkdir -p "$BUILD_DIR"
mkdir -p "$EXAMPLES_DIR"
mkdir -p "$JEKYLL_DIR/_categories"
mkdir -p "$DATA_DIR"

# Function to compile civet
compile_civet() {
    local input="$1"
    local output="$2"
    if civet -c "$input" -o "$output" 2>/dev/null; then
        echo "Compiled $input"
    else
        echo "Failed to compile $input, skipping"
        return 1
    fi
}

# Generate examples and categories data
echo "examples:" > "$DATA_DIR/examples.yml"
echo "categories:" > "$DATA_DIR/categories.yml"
seen_categories=""

# Find all .civet files
find "$CIVET_DIR" -name "*.civet" | while read -r file; do
    # Get category and slug
    category=$(basename "$(dirname "$file")")
    slug=$(basename "$file" .civet)

    # Compile
    output_dir="$BUILD_DIR/$category"
    mkdir -p "$output_dir"
    if ! compile_civet "$file" "$output_dir/$slug.js"; then
        continue
    fi

    # Create example page
    cat > "$EXAMPLES_DIR/$slug.md" << EOF
---
layout: example
title: "Example $slug"
category: $category
slug: $slug
---
EOF

    # Add to data
    echo "  - slug: $slug" >> "$DATA_DIR/examples.yml"
    echo "    category: $category" >> "$DATA_DIR/examples.yml"
    echo "    title: \"Example $slug\"" >> "$DATA_DIR/examples.yml"

    # Track categories
    if [[ "$seen_categories" != *"$category"* ]]; then
        seen_categories="$seen_categories $category"
        echo "  - slug: $category" >> "$DATA_DIR/categories.yml"
        echo "    name: \"$category\"" >> "$DATA_DIR/categories.yml"

        # Create category page
        cat > "$JEKYLL_DIR/_categories/$category.md" << EOF
---
layout: category
title: "$category Examples"
category: $category
---
EOF
    fi
done

echo "Build complete."