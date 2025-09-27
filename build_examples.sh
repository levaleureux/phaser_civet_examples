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
mkdir -p "$DATA_DIR"

# Function to compile civet
compile_civet() {
    local input="$1"
    local output="$2"
    civet -c "$input" -o "$output"
}

# Generate examples data
echo "examples:" > "$DATA_DIR/examples.yml"

# Find all .civet files
find "$CIVET_DIR" -name "*.civet" | while read -r file; do
    # Get category and slug
    category=$(basename "$(dirname "$file")")
    slug=$(basename "$file" .civet)

    # Compile
    output_dir="$BUILD_DIR/$category"
    mkdir -p "$output_dir"
    compile_civet "$file" "$output_dir/$slug.js"

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
done

echo "Build complete."