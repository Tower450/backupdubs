# Store the OS type
$OS_TYPE = Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty Caption

# Default USB mount path (Windows drives are under 'D:', 'E:', etc. based on the system)
$BASE_MOUNT = "E:\"  # Adjust if needed to match your system's mount point.

# Define the file types to search for
$FILE_TYPES = "*.mp3", "*.wav", "*.flac", "*.ogg", "*.aac", "*.m4a"

# Default flag value (keep structure)
$KEEP_STRUCTURE = $true

# Function to list available drives
function List-UsbDrives {
    Write-Host "Available USB drives:"
    Get-WmiObject -Class Win32_Volume | Where-Object {$_.DriveType -eq 2} | Select-Object -ExpandProperty Name
}

# Parse command-line arguments
param(
    [string]$USB_NAME,
    [switch]$NoStructure
)

# Set flag if --no-structure is used
if ($NoStructure) {
    $KEEP_STRUCTURE = $false
}

# If USB_NAME is not provided, list USB drives and prompt for selection
if (-not $USB_NAME) {
    Write-Host "No USB name provided."
    List-UsbDrives
    $USB_NAME = Read-Host "Please enter the name of the USB drive"
}

$USB_MOUNT = "$BASE_MOUNT\$USB_NAME"

# Check if the USB exists
if (-not (Test-Path -Path $USB_MOUNT)) {
    Write-Host "Error: USB drive '$USB_NAME' not found at $USB_MOUNT."
    exit
}

# Set destination directory to the current directory
$DEST_DIR = ".\Audio_Backup"

# Create the destination directory if it doesn't exist
if (-not (Test-Path -Path $DEST_DIR)) {
    New-Item -ItemType Directory -Path $DEST_DIR
}

Write-Host "Searching for audio files on $USB_MOUNT..."

# Search for audio files and copy them
Get-ChildItem -Path $USB_MOUNT -Recurse -File | Where-Object { $_.Extension -in $FILE_TYPES } | ForEach-Object {
    $file = $_
    Write-Host "Copying file: $file"

    if ($KEEP_STRUCTURE) {
        # Preserve folder structure (relative to USB_NAME)
        $relativePath = $file.FullName.Substring($USB_MOUNT.Length)

        # Create the directory structure under DEST_DIR if it doesn't exist
        $destinationPath = Join-Path -Path $DEST_DIR -ChildPath "$USB_NAME$relativePath"
        $destinationDir = [System.IO.Path]::GetDirectoryName($destinationPath)

        if (-not (Test-Path -Path $destinationDir)) {
            New-Item -ItemType Directory -Path $destinationDir
        }

        # Now copy the file while keeping the folder structure
        Copy-Item -Path $file.FullName -Destination $destinationPath
    }
    else {
        # Copy all files directly to destination (without folder structure)
        Copy-Item -Path $file.FullName -Destination $DEST_DIR
    }
}

Write-Host "All audio files have been copied to $DEST_DIR."

