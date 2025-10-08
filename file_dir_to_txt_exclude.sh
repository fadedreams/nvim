#!/bin/bash

# Output file in the current working directory (Vim's project directory)
output_file="$(pwd)/all.txt"

# Directories to exclude (space-separated)
exclude_dirs=("node_modules" "target" ".git" "resources" ".idea" ".vscode" "__pycache__" "venv" ".venv" ".mypy_cache" ".pytest_cache" "build" "dist" "out" "docs" "venv" "env"  "__pycache__")

# Files to exclude (space-separated)
exclude_files=("LICENSE" "file_dir_to_txt_exclude.sh" ".gitignore" "serverall.js" ".env" "all.txt" "go.sum" "package-lock.json" "yarn.lock" ".next" ".env.local" ".env.development.local" ".env.production.local" ".env.test.local" ".env.development" ".env.production" ".env.test" ".DS_Store" "Thumbs.db" "desktop.ini" "*.swp" "*.swo" "*.swn" "*.swm" "*.swl" "*.swk" "*.swj" "*.swh" "*.swc" "*.swb" "*.swo" "*.swn" "*.swm" "*.swl" "*.swk" "*.swj" "*.swh" "*.swc" "*.swb" "*.swp" "*.swo" "*.swn" "*.swm" "*.swl" "*.swk" "*.swj" "*.swh" "*.swc" "*.swb")

# Clear the output file if it exists
>"$output_file"

# Function to check if a path contains any of the excluded directories
contains_excluded_dir() {
    local path="$1"
    for dir in "${exclude_dirs[@]}"; do
        if [[ "$path" == *"/$dir/"* || "$path" == *"/$dir" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to check if a file is in the exclude list
is_excluded_file() {
    local filename="$(basename "$1")"
    for excluded in "${exclude_files[@]}"; do
        if [[ "$filename" == "$excluded" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to process a file
process_file() {
    local file="$1"

    # Skip if file path contains excluded directory
    if contains_excluded_dir "$file"; then
        return
    fi

    # Skip if file is in exclude list
    if is_excluded_file "$file"; then
        return
    fi

    # Skip binary files and only process text files
    if file "$file" | grep -q "text"; then
        echo "Processing: $file"
        echo "=== $file ===" >>"$output_file"
        cat "$file" >>"$output_file"
        echo -e "\n\n" >>"$output_file"
    fi
}

# Export functions and variables for subshell usage
export -f process_file
export -f contains_excluded_dir
export -f is_excluded_file
export output_file
export exclude_dirs
export exclude_files

# Main execution
echo "Starting file traversal..."
find . -type f -not -path '*/\.*' -print0 | while IFS= read -r -d '' file; do
    process_file "$file"
done

echo "Contents of all files have been saved to $output_file"
