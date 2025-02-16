#!/bin/bash

# Define the destination directory
destination_dir="./export_rekordbox_files"

# Create the destination directory if it does not exist
if [ ! -d "$destination_dir" ]; then
    mkdir -p "$destination_dir"
    echo "Created destination directory: $destination_dir"
fi

# Find the database file
db_path=$(find /Users/$(whoami)/Library/Pioneer -type f -name "networkAnalyze*.db" 2>/dev/null)

# Check if the database was found
if [ -z "$db_path" ]; then
    echo "No networkAnalyze database found."
    exit 1
fi

# Query to get the list of SongFilePaths from the database
sqlite3 "$db_path" "SELECT SongFilePath FROM manage_tbl;" | while read source_path; do
    # Check if the file exists before attempting to copy
    if [ -f "$source_path" ]; then
        # Get the file name from the source path
        file_name=$(basename "$source_path")
        
        # Copy the file to the destination directory
        cp "$source_path" "$destination_dir/$file_name"
        echo "Copied: $source_path to $destination_dir/$file_name"
    else
        echo "File does not exist: $source_path"
    fi
done

