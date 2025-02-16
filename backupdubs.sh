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

# Function to display help
show_help() {
    echo ""
    echo "                               BACKUPDUBS.SH                       "
    echo ""
    echo ""
    echo "                                       -  =......:......---        "
    echo "                                      .*..**+++=======-+:  .       "
    echo "                                   + +@#..++=========--* .  -::    "
    echo "                                   *#@@%=:+*==========-+=  :-::.   "
    echo "                                  .++#@*+++*===========+=----:::   "
    echo "                                  -#*+%#+++#********+++++++++-+:   "
    echo "                                  +#:-+:.=..==:::::::----=--==+-   "
    echo "                                  ***=++=-:   -------=   =---++*:  "
    echo "        ####*********#**=         *#%*++:..:-----:------:-::-*++-  "
    echo "        ####******=....+=   ..   :#*+=*:*=:--==.    :::--:.-:===:  "
    echo "     =%#+  -  .---     =-   -:   +#+++**@#.--+*-    :----...:+=-:  "
    echo "    =@@#######*****++++*-  .*-  .#%***#+%@*.===++====--- .--.++-.. "
    echo "    .#@#*####***********==+-==--=@@***##=@@@#- ------. -++= :-**-- "
    echo "     :-@@@@@@@@@@@@@@@@@%-*+**###@@:+==***-@@@@@@@@@@@@%#..+--*=:: "
    echo "      .@@@@@@@@@@@@@@@@@@%%%%#####%+*+**++*#* +@@@@@@* .-----=*=-: "
    echo "                            .:::::@.+--+++++++++====---------=+++- "
    echo "                             .::::%****###@@@@@@@@%@@@@%%@%@@@@@@@+"
    echo "                              ....%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+"
    echo "                               ...%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@."
    echo "                               ...#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "
    echo "                                  :++++*++==------------------:.   "
    echo ""
    echo "backubdubs.sh"
    echo "Usage: $0 [USB_NAME] [OPTIONS]"
    echo ""
    echo "Retrieve all audio files from a USB drive and copy them to a destination folder."
    echo ""
    echo "Options:"
    echo "  -d, --destination PATH   Specify the destination directory (default: ./Audio_Backup)"
    echo "      --no-structure       Do not preserve folder structure, flatten instead (default: keep structure)"
    echo "  --export-from-rekordbox  Export files from Rekordbox to ./export_from_rekordbox_files"
    echo "  -h, --help               Show this help message and exit"
    echo ""
    echo "Examples:"
    echo "  $0 MyUSB                Copy files from 'MyUSB' with folder structure to './Audio_Backup'"
    echo "  $0 MyUSB -d /path/to/dest   Copy files from 'MyUSB' to '/path/to/dest'"
    echo "  $0 MyUSB --no-structure -d /dest Copy without folder structure"
    exit 0
}

# Function to list mounted USB drives
list_usb_drives() {
    echo "Available USB drives:"
    ls "$BASE_MOUNT"
}

# Function to export from Rekordbox
db_export_from_rekordbox() {
    export_dir="./export_from_rekordbox_files"
    mkdir -p "$export_dir"
    db_path=$(find /Users/$(whoami)/Library/Pioneer -type f -name "networkAnalyze*.db" 2>/dev/null)
    if [ -z "$db_path" ]; then
        echo "No networkAnalyze database found."
        exit 1
    fi
    sqlite3 "$db_path" "SELECT SongFilePath FROM manage_tbl;" | while read source_path; do
        if [ -f "$source_path" ]; then
            cp "$source_path" "$export_dir/$(basename "$source_path")"
            echo "Copied: $source_path"
        else
            echo "File does not exist: $source_path"
        fi
    done
    echo "Export completed to $export_dir"
}

# Default values
KEEP_STRUCTURE=true
DEST_DIR="./Audio_Backup"

# Parse command line options
while [[ $# -gt 0 ]]; do
    case $1 in
        --no-structure)
            KEEP_STRUCTURE=false
            shift
            ;;
        -d|--destination)
            DEST_DIR=$2
            shift 2
            ;;
        --export-from-rekordbox)
            db_export_from_rekordbox
            exit 0
            ;;
        -h|--help)
            show_help
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

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

echo "Searching for audio files on $USB_MOUNT..."

# Find audio files and copy them
find "$USB_MOUNT" -type f \( -iname "*.mp3" -o -iname "*.wav" -o -iname "*.flac" -o -iname "*.ogg" -o -iname "*.aac" -o -iname "*.m4a" \) | while read file; do
    echo "Copying file: $file"  # Logging the file being copied

    if $KEEP_STRUCTURE; then
        relative_path="${file#$USB_MOUNT/}"
        mkdir -p "$DEST_DIR/$USB_NAME/$(dirname "$relative_path")"
        cp "$file" "$DEST_DIR/$USB_NAME/$relative_path"
    else
        cp "$file" "$DEST_DIR"
    fi
done

echo "All audio files have been copied to $DEST_DIR."

echo "Cleaning up opened files (rsync leftover)"
lsof "$USB_MOUNT" | awk 'NR>1 {print $2}' | xargs kill -9

