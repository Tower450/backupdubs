# Makefile for BackupDubs (Bash and PowerShell versions)

.PHONY: all help bash-list bash-usb bash-no-structure bash-custom-dest ps-list ps-usb ps-no-structure ps-custom-dest

all: help

help:
	@echo "Available targets:"
	@echo "  bash-list            List available USB drives (bash)"
	@echo "  bash-usb             Backup from USB with structure (bash)"
	@echo "  bash-no-structure    Backup without structure (bash)"
	@echo "  bash-custom-dest     Backup to custom destination (bash)"
	@echo "  ps-list              List available USB drives (PowerShell)"
	@echo "  ps-usb               Backup from USB with structure (PowerShell)"
	@echo "  ps-no-structure      Backup without structure (PowerShell)"
	@echo "  ps-custom-dest       Backup to custom destination (PowerShell)"

# Bash targets
bash-list:
	./backupdubs.sh --help

bash-usb:
	./backupdubs.sh MyUSBDrive

bash-no-structure:
	./backupdubs.sh MyUSBDrive --no-structure

bash-custom-dest:
	./backupdubs.sh MyUSBDrive -d ./MyBackupFolder

# PowerShell targets
ps-list:
	pwsh -File ./backupdubs.ps1 -Help

ps-usb:
	pwsh -File ./backupdubs.ps1 -USB_NAME "MyUSBDrive"

ps-no-structure:
	pwsh -File ./backupdubs.ps1 -USB_NAME "MyUSBDrive" -NoStructure

ps-custom-dest:
	pwsh -File ./backupdubs.ps1 -USB_NAME "MyUSBDrive" -Destination "C:\\MyBackup"
