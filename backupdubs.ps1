# Parse command-line arguments
param(
    [string]$USB_NAME,
    [switch]$NoStructure,
    [string]$Destination = ".\Audio_Backup",
    [switch]$Help,
    [switch]$ExportFromRekordBox  # New flag for Rekordbox export
)

# Help function
function Show-Help {
    Write-Host @"
			BACKUPDUBS - PowerShell Version


                                       -  =......:......---        
                                      .*..**+++=======-+:  .       
                                   + +@#..++=========--* .  -::    
                                   *#@@%=:+*==========-+=  :-::.   
                                  .++#@*+++*===========+=----:::   
                                  -#*+%#+++#********+++++++++-+:   
                                  +#:-+:.=..==:::::::----=--==+-   
                                  ***=++=-:   -------=   =---++*:  
        ####*********#**=         *#%*++:..:-----:------:-::-*++-  
        ####******=....+=   ..   :#*+=*:*=:--==.    :::--:.-:===:  
     =%#+  -  .---     =-   -:   +#+++**@#.--+*-    :----...:+=-:  
    =@@#######*****++++*-  .*-  .#%***#+%@*.===++====--- .--.++-.. 
    .#@#*####***********==+-==--=@@***##=@@@#- ------. -++= :-**-- 
     :-@@@@@@@@@@@@@@@@@%-*+**###@@:+==***-@@@@@@@@@@@@%#..+--*=:: 
      .@@@@@@@@@@@@@@@@@@%%%%#####%+*+**++*#* +@@@@@@* .-----=*=-: 
                            .:::::@.+--+++++++++====---------=+++- 
                             .::::%****###@@@@@@@@%@@@@%%@%@@@@@@@+
                              ....%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+ 
                               ...%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@. 
                               ...#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
                                  :++++*++==------------------:.   
                                                        

Usage:
    .\backupdubs.ps1 [-USB_NAME <USB Name>] [-NoStructure] [-Destination <Path>] [-Help] [-ExportFromRekordBox]

Parameters:
    -USB_NAME        : Specify the USB drive name or path (e.g., "E:\").
    -NoStructure     : Copy all files into a single folder (no directory structure).
    -Destination     : Specify the destination folder for copied audio files.
    -Help             : Show this help information.
    -ExportFromRekordBox : Export audio files from the Rekordbox database to a specified directory.

Examples:
    .\backupdubs.ps1 -USB_NAME "E:\" -Destination "C:\Backup"
    .\backupdubs.ps1 -NoStructure"
    .\backupdubs.ps1 -ExportFromRekordBox"
"@
    exit
}

# Show help if requested
if ($Help) {
    Show-Help
}

# If ExportFromRekordBox flag is set, execute Rekordbox export logic
if ($ExportFromRekordBox) {
    Install-Module -Name PSSQLite -Force -AllowClobber
    Import-Module PSSQLite

    $userLibraryPath = Join-Path -Path $env:USERPROFILE -ChildPath "AppData\Roaming"
    $rekordboxDbPath = (Get-ChildItem -Path $userLibraryPath -Recurse -Filter "networkAnalyze*.db" -File -ErrorAction SilentlyContinue).FullName
    $exportDir = "./export_from_rekordbox_files"

    # Run script to export/backup from rekordbox in playlist folders.
    python "./scripts/backupdubs_pyrekordbox.py"  "$exportDir"
    if ($LASTEXITCODE -eq 0) {
        Write-Output "Pyrekordbox script executed successfully!"
    } else {     
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

              if (-not (Test-Path -Path "$destination")) {
                  Copy-Item -Path $filePath -Destination $destination
              } else {
                  Write-Host "File already exists $destination\$fileName"
              }
              Write-Output "Copied: $filePath to $destination"
          }
      }
    }
    Write-Output "Export completed to $exportDir"
    exit
}

# Store the OS type
$OS_TYPE = Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty Caption

# Define the file types to search for
$FILE_TYPES = @('.mp3', '.wav', '.flac', '.aac', '.ogg')

# Default flag value (keep structure)
$KEEP_STRUCTURE = -not $NoStructure

# Function to list available drives
function List-UsbDrives {
    Write-Host "Available USB drives:"
    Get-WmiObject -Class Win32_Volume | Where-Object {$_.DriveType -eq 2} | Select-Object -ExpandProperty Name
}

# If USB_NAME is not provided, list USB drives and prompt for selection
if (-not $USB_NAME) {
    Write-Host "No USB name provided."
    List-UsbDrives
    $USB_NAME = Read-Host "Please enter the name of the USB drive"
}

$USB_MOUNT = "$USB_NAME"

# Check if the USB exists
if (-not (Test-Path -Path $USB_MOUNT)) {
    Write-Host "Error: USB drive '$USB_NAME' not found at $USB_MOUNT."
    exit
}

# Create the destination directory if it doesn't exist
if (-not (Test-Path -Path $Destination)) {
    New-Item -ItemType Directory -Path $Destination
}

Write-Host "Searching for audio files on $USB_MOUNT..."

# Search for audio files and copy them
Get-ChildItem -Path $USB_MOUNT -Recurse -File | Where-Object {
    $ext = $_.Extension.ToLower()
    $ext -in $FILE_TYPES
} | ForEach-Object {
    $file = $_

    Write-Host "Copying file:" $file.FullName
    Write-Host "To:" $Destination

    if ($KEEP_STRUCTURE) {
        # Preserve folder structure (relative to USB_NAME)
        $relativePath = $file.FullName.Substring($USB_MOUNT.Length)
        $destinationPath = Join-Path -Path $Destination -ChildPath $relativePath

        $destinationFolder = Split-Path -Path $destinationPath -Parent
        if (-not (Test-Path -Path $destinationFolder)) {
            New-Item -ItemType Directory -Path $destinationFolder -Force
        }

        if (-Not (Test-Path -Path "$destinationPath\$file.FullName")) {
            Copy-Item -LiteralPath $file.FullName -Destination "$destinationPath"
        } else {
            Write-Host "File already exists: $destinationPath"
        }
    }
    else {
        # Copy all files directly to destination
        if (-Not (Test-Path -Path "$Destination\$file")) {
            Copy-Item -LiteralPath $file.FullName -Destination "$Destination"
        } else {
            Write-Host "File already exists: $Destination\$file"
        }
    }
}

Write-Host "All audio files have been copied to $Destination."
