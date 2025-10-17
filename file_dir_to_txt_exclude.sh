#!/bin/bash

# Output file in the current working directory
output_file="$(pwd)/all.txt"

# Directories to exclude
exclude_dirs=("node_modules" "target" ".git" "resources" ".idea" ".vscode" "__pycache__" "venv" ".venv" ".mypy_cache" ".pytest_cache" "build" "dist" "out" "docs" "env")

# Extensions to exclude (CSS + IMAGES)
exclude_ext="css png jpg jpeg gif bmp webp ico tiff tif svg psd ai eps pdf heic heif avif jp2 j2k jxr wdp cur ani xpm pcx tga exr hdr pbm pgm ppm pfm pict"

# Exact files to exclude
exclude_files="LICENSE package-lock.json bun.lock file_dir_to_txt_exclude.sh .gitignore serverall.js .env all.txt go.sum package-lock.json yarn.lock .next .DS_Store Thumbs.db desktop.ini"

# Clear output file
>"$output_file"

# Function to check excluded directories
contains_excluded_dir() {
    local path="$1"
    for dir in $exclude_dirs; do
        if [[ "$path" == *"/$dir/"* || "$path" == *"/$dir"* ]]; then
            return 0
        fi
    done
    return 1
}

# Function to check if file should be EXCLUDED
should_exclude() {
    local file="$1"
    local filename="${file##*/}"  # basename
    local ext="${filename##*.}"   # extension
    
    # Skip if in excluded directory
    if contains_excluded_dir "$file"; then
        return 0
    fi
    
    # Skip exact files
    if echo "$exclude_files" | grep -qw "$filename"; then
        return 0
    fi
    
    # Skip CSS and images by extension
    if echo "$exclude_ext" | grep -qw "$ext"; then
        return 0
    fi
    
    return 1
}

# Function to process file
process_file() {
    local file="$1"
    
    # If NOT excluded, process it
    if ! should_exclude "$file"; then
        if file "$file" | grep -q "text"; then
            echo "Processing: $file"
            echo "=== $file ===" >>"$output_file"
            cat "$file" >>"$output_file"
            echo -e "\n\n" >>"$output_file"
        fi
    fi
}

# Export everything
export -f process_file
export -f contains_excluded_dir
export -f should_exclude
export output_file
export exclude_dirs
export exclude_ext
export exclude_files

# MAIN: Use find to exclude CSS/IMAGES at SEARCH TIME!
echo "Starting file traversal..."
find . \
    -type f \
    -not -path '*/\.*' \
    -not -name "*.css" \
    -not -name "*.png" \
    -not -name "*.jpg" \
    -not -name "*.jpeg" \
    -not -name "*.gif" \
    -not -name "*.bmp" \
    -not -name "*.webp" \
    -not -name "*.ico" \
    -not -name "*.tiff" \
    -not -name "*.tif" \
    -not -name "*.svg" \
    -not -name "*.psd" \
    -not -name "*.ai" \
    -not -name "*.eps" \
    -not -name "*.pdf" \
    -not -name "*.heic" \
    -not -name "*.heif" \
    -not -name "*.avif" \
    -print0 | while IFS= read -r -d '' file; do
    process_file "$file"
done

echo "Done! Check $output_file"
