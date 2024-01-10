#!/bin/bash

# Define the path to the images and project directories
IMAGE_PATH="/home/tcl-dev/sooraj/projects/newWebsite/src/components/assets/images"
PROJECT_PATH="/home/tcl-dev/sooraj/projects/newWebsite" # replace with your project path

# Temporary file to store image names
patterns_file=$(mktemp)

# Find image files and store their names in the temporary file
find "$IMAGE_PATH" -type f \( -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \) -exec basename "{}" \; > "$patterns_file"

# Create an array to store image variables from the JavaScript/TypeScript file
declare -a image_variables=($(grep -hoP 'require\(".*?\/(.*?)"\)' "$PROJECT_PATH" | sed -E 's/require\(".*\/(.*)"\)/\1/'))

# Scan the project for each image file and variable
while read -r image_name; do
    if ! grep -Rq "$image_name" "$PROJECT_PATH" || [[ ! " ${image_variables[@]} " =~ " $image_name " ]]; then
        # Image not found in project or not used with object key, so delete it
        rm "$IMAGE_PATH/$image_name"
        echo "Deleted unused image: $image_name"
    else
        echo "Image is used: $image_name"
    fi
done < "$patterns_file"

# Remove the temporary file
rm "$patterns_file"

echo "Cleanup complete."
