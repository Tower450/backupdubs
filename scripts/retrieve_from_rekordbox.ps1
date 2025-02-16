Install-Module PSSQLite
Import-Module PSSQLite

$userLibraryPath = Join-Path -Path $env:USERPROFILE -ChildPath "AppData\Roaming"
$rekordboxDbPath = (Get-ChildItem -Path $userLibraryPath -Recurse -Filter "networkAnalyze*.db" -File -ErrorAction SilentlyContinue).FullName
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
$query = "SELECT SongFilePath FROM manage_tbl;"
$files = Invoke-SqliteQuery -DataSource $rekordboxDbPath -Query $query
foreach ($file in $files) {
    # Extract the SongFilePath from each result
    $filePath = $file.SongFilePath

    # Check if the file exists
    if (-Not (Test-Path -Path $filePath)) {
        Write-Output "File not found: $filePath"
    } else {
        # Get the file name from the path and copy the file
        $fileName = Split-Path -Path $filePath -Leaf
        $destination = Join-Path -Path $exportDir -ChildPath $fileName

        Copy-Item -Path $filePath -Destination $destination
        Write-Output "Copied: $filePath to $destination"
    }
}

Write-Output "Export completed to $exportDir"
