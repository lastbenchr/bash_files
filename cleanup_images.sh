#!/bin/bash

# Define the path to the images and project directories
IMAGE_PATH="C:/Users/john/Desktop/test/images/"
PROJECT_PATH="C:/Users/john/Desktop/test" # replace with your project path

# Temporary file to store image names
patterns_file=$(mktemp)

# Find image files and store their names in the temporary file
find "$IMAGE_PATH" -type f \( -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \) -exec basename {} \; > "$patterns_file"

# Scan the project for each image file
while read -r image_name; do
    if ! grep -Rq "$image_name" "$PROJECT_PATH"; then
        # Image not found in project, so delete it
        rm "$IMAGE_PATH$image_name"
        echo "Deleted unused image: $image_name"
    else
        echo "Image is used: $image_name"
    fi
done < "$patterns_file"

# Remove the temporary file
rm "$patterns_file"

echo "Cleanup complete."

# Save this script to a file, for example cleanup_images.sh, and make it executable with chmod +x cleanup_images.sh. Run the script with ./cleanup_images.sh from your terminal.