#!/bin/bash

# Store uname output in a variable
OS_TYPE=$(uname)

# Detect OS once
if [[ "$OS_TYPE" == "Darwin" ]]; then
    OS="macOS"
    BASE_MOUNT="/Volumes"
else
    OS="Linux"
    BASE_MOUNT="/media/$USER"
fi

# Function to list mounted USB drives
list_usb_drives() {
    echo "Available USB drives:"
    ls "$BASE_MOUNT"
}

# Default flag value (keep structure)
KEEP_STRUCTURE=true

# Parse command line options
while [[ $# -gt 0 ]]; do
    case $1 in
        --no-structure)
            KEEP_STRUCTURE=false
            shift
            ;;
        *)
            if [ -z "$USB_NAME" ]; then
                USB_NAME=$1
            fi
            shift
            ;;
    esac
done

# If USB name is not provided
if [ -z "$USB_NAME" ]; then
    echo "No USB name provided."
    list_usb_drives
    read -p "Please enter the name of the USB drive: " USB_NAME
fi

USB_MOUNT="$BASE_MOUNT/$USB_NAME"

# Check if USB exists
if [ ! -d "$USB_MOUNT" ]; then
    echo "Error: USB drive '$USB_NAME' not found at $USB_MOUNT."
    exit 1
fi

# Destination directory
DEST_DIR="./Audio_Backup"

# File types to look for
FILE_TYPES="*.mp3 *.wav *.flac *.ogg *.aac *.m4a"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

echo "Searching for audio files on $USB_MOUNT..."

# Find audio files and copy them
find "$USB_MOUNT" -type f \( -iname "*.mp3" -o -iname "*.wav" -o -iname "*.flac" -o -iname "*.ogg" -o -iname "*.aac" -o -iname "*.m4a" \) | while read file; do
    echo "Copying file: $file"  # Logging the file being copied

    if $KEEP_STRUCTURE; then
        # Preserve folder structure (relative to USB_NAME)
        relative_path="${file#$USB_MOUNT/}"

        # Create the directory structure under DEST_DIR if it doesn't exist
        mkdir -p "$DEST_DIR/$USB_NAME/$(dirname "$relative_path")"

        # Now copy the file while keeping the folder structure
        cp "$file" "$DEST_DIR/$USB_NAME/$relative_path"
    else
        # Copy all files directly to destination
        # rsync -R "$file" "$DEST_DIR"
        cp "$file" "$DEST_DIR"
    fi
done

echo "All audio files have been copied to $DEST_DIR."

