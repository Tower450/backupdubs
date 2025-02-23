# backupdubs.sh

[platform-linux-badge]: https://img.shields.io/badge/platform-linux-brightgreen
[platform-macos-badge]: https://img.shields.io/badge/platform-macos-lightgrey
[platform-windows-badge]: https://img.shields.io/badge/platform-windows-blue
[license-badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license-link]: https://opensource.org/licenses/MIT

A USB backup program for DJ.
Usefull if your computer or laptop get stolen and the only thing you have left is your dj usb key.


                                                       r   î    ›    –   ·    ·‘‚˜›           
                                                       {   ì6ç£wY±Ïó@@ò¢¤ƒïì{×¼               
                                                     ‘ž{  `ìs^|÷¦—ª¯^——ª“„„”º³3               
                                                ˆõ  7ÔP/  ¨ïÌ¡|¯¡—¡—¡!—¦¯¦¯””ºð ~|  ¹  `      
                                                ¦‡‡5Dâ¥}  ¨†0«¬!÷¦!|¦¯^÷÷¯—¦¯”ô˜    “ ´ `     
                                                t¤vz&8ÿì<¿«iô÷¡¡!|¬¦¬¬•¡¦^“„~”ô»|¦– ‚´´       
                                                Îjvo¼äý?){«[O¬«»|¯^¯)÷¦ª¯^¦!¯—w¦“­º˜…         
                                                àžßêZ¼d}(/)«µ&&çÍò¢öIJjci††}¿»[—“º~¹››‡Ýº     
                                                ñkö‡r¬ûŸžOe6Oô2±©©óCöu%¤Jtvlìí7?¿}(»«³»       
                                                à6³³’¯5|³‘Ï³³”)ÿ           3—ƒ­’oº7º°¿…       
                                                Pu³„´ª0•|¯^¬     º°’‚‚›…¨;/²    ƒ~(… ú°˜r{    
            ;ˆˆ¨˜‚´         ¨ …`                kn©ÍV”V÷ª­    º›››‘’¸:‚’‘…ˆˆˆ¹¿ 1 ¯ `ô{ /•    
           òs¼¢¢ƒ¤ttIIctoîvjIItc¤I—             ŸuCnI°L÷ ‹0 ~~²­­›:¯    =¨`¨…´ ª  z  %º´`     
           £3sòòs‰‡ƒ‡%¤¤cî‹:’‘:’×j„     †      ~Z‰´ +~ü {§  ““²°I²›      „¨  ˜¨ ¿  í ”)‘l¨    
        ¦i‡ç     ¨ „  C          1~    ¸‡      l9í>*(„& ýä  ²„”^µ¹º       ¸­`………–   ¹ < ì´    
      óPþR2Í}zIünIzîÏs‡Iz        c·           ›a®¼>Ì>»& ýû® •„„^/yO¿°°~­¹ì÷‘˜‚‚’    ‚²ìú´     
      óŸâëÏn@@ò@Cns¼‡¼¼‰½¼JJJƒI¤ƒz     ôÄ’    ªDS¿{×{)è $škU  /—^“ª¦)¿}„‚‘‘:’…´ ¨—:‘ ·<j“     
      ’ZpDó‰¼suòò¢¼¤J¤¤¤tt¤Iî%Jz‡‰‘           /Þ§çcóÏ/US ÕPhûš¡  )¦º––;;˜›“   ”I</¬  ‚>«=“­ ³ 
         †ÿåÓèÓèÓÞÞÖåèýèÞddëÙýëèèøçªv²’¦([iïrîúýTº³}³¬y%y @ëá¥ÿÙáào…˜    ­‡6S¾ü@u»  …’ï“?³­   
         º$ÙÙ$d$ëëÜéðéëdëdë$Üdèý$83ìfû®khàÝûšäábý³³²³»5[lòS´ Zðdëé¶¶¶ãâã8ÙÞñÇž5‘  º¾£­7ªî`    
          ñ8ééGø¶mG¶âã¶¶¶øGâ¶Úé8$8Óx¾õ™2wY0Í03C@õ†º¸)¡2××¿íc‰ú¯ ´ìUßœœÐgÔ¥u:   ÷­²­‹‹;»cÍ……   
                     ˆˆ ·’‚ˆ·’           ·’›;›–^Þ rtu ü+//)*××¿>>tVü±ƒ=î¼o/^ºº~²~º³°~“„ôxôa)  
                                               ~Oò   ¦ú×?*{{+}*}**•*{*(»+/++}×?iì<=i>l=®„„²ª² 
                                               ›ZTTžk®Ÿ®®®0fûŸŸŸŸ®§hÇ§hPZPZñ¥DbbåÞ¾FÓÜëèýåšFF„
                                                žèèýÙÙýýýÓÚø¶$Ü$Ú8ÚÚ$¶é8â8øGø¶øGøéådé8é$dÚdýÿ 
                                               ´ŸÙÙdýdÙÙdýðAâøøøðø¶ãmâââmGãããßãpmGÓ8¶ððð8$ýÓÓ 
                                                kÚ$$é8$8éøâÔãmãããmpm€mã€€AAAÔA€ÔÔã$â¶ø¶øGð$Úè 
                                                kééøâGãmppßÕêÕÕŠÛÛÛqqŠÛêêgêœXêêÐgÔã€ÔÔp€ßâøðâ 
                                                fßÕ€pApmm¶G6ò‰ƒr1=i×¿<i?[?*††¿i??rž¥äûÝSfaw×  
                                                                                              
                                                                                              
                                                                                                                            
                                                                                                                            
                                                                                                                                                                                                                                                       
## `backupdubs.sh`

This script allows you to copy all audio files from a USB drive to your local machine, with the option to either preserve or flatten the folder structure.

## Features:
- **Copies audio files** from USB drives.
- Supports the following audio file formats: `.mp3`, `.wav`, `.flac`, `.ogg`, `.aac`, `.m4a`.
- **Preserves folder structure** by default, or can **flatten the folder structure** with a flag (`--no-structure`).
- Logs each file being copied for easy tracking.
- Export all tracks in Rekordbox library inside a folder (flatten).

## Prerequisites:
- The script has been tested on **macOS**,**Linux** and *Windows*.
- The USB drive must be mounted and accessible.
- Install sqlite3 and sqlcipher (rekordbox export)

Linux / MacOS
**Don't forget to make it executable**
```bash
chmod a+x
```

Windows

```ps
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
```

## Usage:

### Basic Usage (MacOS and Linux):

```bash
./backupdubs.sh --help
```

Will list you usb available to backup and start the operation.

```bash
./backupdubs.sh
```

This will copy all the audio files and keep folder structure into the `./AudioBackup` directory.
```bash
./backupdubs.sh <USB_NAME>
```

This will copy all audio files into the `./AudioBackup` directory without preserving the folder structure.
```bash
./backupdubs.sh <USB_NAME> --no-structure
```

Set destination

```bash
./backupdubs.sh -d ./backup
```

```bash
./backupdubs.sh --destination ./backup
```

Rekordbox export

Will retrieve all existing tracks in rekordbox and flat it into a single folder.

```bash
./backupdubs.sh --export-from-rekordbox
```

---

### Basic Usage (Windows)

```pwsh
./backupdubs.ps1 -Help
```

This will copy all the audio files and keep folder structure into the `./AudioBackup` directory.
```pwsh
.\backupdubs.ps1 -USB_NAME "MyUSBDrive"
```

This will copy all audio files into the `./AudioBackup` directory without preserving the folder structure
```pwsh
.\backupdubs.ps1 -USB_NAME "MyUSBDrive" -NoStructure
```

Set destination

```pwsh
./backupdubs.ps1 -Destination ./backup
```

Rekordbox export

Will retrieve all existing tracks in rekordbox and flat it into a single folder.

```pwsh
.\backupdubs.ps1 -ExportFromRekordBox
```
