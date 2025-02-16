# PowerShell Script: Export from Rekordbox on Windows

# Define Rekordbox database path for Windows
$rekordboxDbPath = "$env:APPDATA\Pioneer\rekordbox\networkAnalyze.db"
$exportDir = "./export_from_rekordbox_files"

# Create destination directory if it doesn't exist
if (!(Test-Path -Path $exportDir)) {
    New-Item -ItemType Directory -Path $exportDir | Out-Null
    Write-Output "Created destination directory: $exportDir"
}

# Check if the Rekordbox database exists
if (!(Test-Path -Path $rekordboxDbPath)) {
    Write-Output "Rekordbox database not found at $rekordboxDbPath"
    exit
}

# Query the database and export audio files
$files = sqlite3 $rekordboxDbPath "SELECT SongFilePath FROM manage_tbl;"
foreach ($file in $files) {
    if (Test-Path -Path $file) {
        $fileName = Split-Path -Path $file -Leaf
        Copy-Item -Path $file -Destination "$exportDir\$fileName"
        Write-Output "Copied: $file to $exportDir"
    } else {
        Write-Output "File not found: $file"
    }
}

Write-Output "Export completed to $exportDir"
