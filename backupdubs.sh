#!/bin/bash

# Store uname output in a variable
OS_TYPE=$(uname)

# Detect OS once
if [[ "$OS_TYPE" == "Darwin" ]]; then
    OS="macOS"
    BASE_MOUNT="/Volumes"
else
    OS="Linux"
    if [ -f "/etc/arch-release" ]; then # support ArchLinux
        BASE_MOUNT="/run/media/$USER"
    else
        BASE_MOUNT="/media/$USER"
    fi
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
    echo "  --convert320             Convert all .mp3 files under 320kbps bit rate to 320kbps into (./MP3_320)"
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
    # execute script for export/backup from rekordbox
    python3 "./scripts/backupdubs_pyrekordbox.py" "$export_dir"
    if [ $? -eq 0 ]; then
      echo "Pyrekordbox script executed successfully!"
    else
      db_path=$(find /Users/$(whoami)/Library/Pioneer -type f -name "networkAnalyze*.db" 2>/dev/null)
      if [ -z "$db_path" ]; then
          echo "No networkAnalyze database found."
          exit 1
      fi
      sqlite3 "$db_path" "SELECT SongFilePath FROM manage_tbl;" | while read source_path; do
          if [ -f "$source_path" ]; then
              if [ -e "$export_dir/$(basename "$source_path")" ]; then
                echo "File already exists: "$export_dir/$(basename "$source_path")""
              else
                cp "$source_path" "$export_dir/$(basename "$source_path")"
                echo "Copied: $source_path"
              fi
          else
              echo "File does not exist: $source_path"
          fi
      done
    fi
    echo "Export completed to $export_dir"
}

convert_mp3_to_320() {
    local mp3_dest_dir="./MP3_320"

    # Check required tools
    command -v ffprobe >/dev/null 2>&1 || { echo >&2 "ffprobe not found. Please install ffmpeg."; exit 1; }
    command -v lame >/dev/null 2>&1 || { echo >&2 "lame not found. Please install lame."; exit 1; }

    mkdir -p "$mp3_dest_dir"

    for file in "$FOLDER_CONTAINING_MP3"/*.mp3; do
        echo $file
        echo "\n"
        # [ -e "$file" ] || continue  # skip if no .mp3 found

        echo "Checking $file..."

        bitrate=$(ffprobe -v error -select_streams a:0 -show_entries stream=bit_rate \
                  -of default=noprint_wrappers=1:nokey=1 "$file")
        bitrate_kbps=$((bitrate / 1000))

        if [ "$bitrate_kbps" -lt 320 ]; then
            output="$mp3_dest_dir/$(basename "$file")_320.mp3"
            echo "➤ Re-encoding to 320 kbps → $output"
            lame --mp3input -b 320 "$file" "$output"
        else
            echo "✓ $file is already 320 kbps — skipping."
        fi
    done
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
        --convert320)
            FOLDER_CONTAINING_MP3=$2
            convert_mp3_to_320
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
        dest_path="$DEST_DIR/$(basename "$file")" 
        if [ -e "$dest_path" ]; then
            echo "File already exists: $dest_path"
        else
          cp "$file" "$dest_path"
          echo "Copied: $file"
        fi
    fi
done

echo "All audio files have been copied to $DEST_DIR."

echo "Cleaning up opened files (rsync leftover)"
lsof "$USB_MOUNT" | awk 'NR>1 {print $2}' | xargs kill -9

