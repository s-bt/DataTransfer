# File transfer options


## Invoke-Base64FileTransfer.ps1
Transfer files using their base64 encoded values. You could use this for transfering files to RDP or Citrix when file copy is disabled but clipboard sharing is allowed
### Usage:
Convert the content of a file to base64 and copy it to the clipboard
```powershell
. .\Invoke-Base64FileTransfer.ps1
Invoke-Base64FileCopy -InputFile C:\myFiles\File.zip
```
Convert the content of the clipboard (must be the base64 representation of a file) to disk
```powershell
. .\Invoke-Base64FileTransfer.ps1
Invoke-Base64FileCopy -OutputFile C:\myFiles\File.zip -ConvertFromBase64
```



