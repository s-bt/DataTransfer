Function Invoke-Base64FileCopy {
    [CmdletBinding(DefaultParameterSetName = 'ToBase64')]
    param(
        [Parameter(Mandatory=$true,ParameterSetName='ToBase64')]
        [string]$InputFile,
        [Parameter(Mandatory=$true,ParameterSetName='FromBase64')]
        [string]$OutputFile
    )
    
    if ($InputFile.Length -gt 0) {
        $TempFileName = "$($env:temp)\temp$(Get-Random -Minimum 100 -Maximum 999).zip"
        Compress-Archive -Path $InputFile -DestinationPath $TempFileName
        $base64string = [Convert]::ToBase64String([IO.File]::ReadAllBytes($TempFileName))
        Set-Clipboard -Value $base64string
        Write-Host "[+] Base64 representation of '$($InputFile)' copied to your clipboard." -ForegroundColor Green
    } elseif ($OutputFile.Length -gt 0) {
        try {
            $Content = [System.Convert]::FromBase64String((Get-Clipboard -ErrorAction Stop))
        } catch {
            Write-Host "[-] Error converting base64 string from clipboard value" -ForegroundColor Red
        }
        $OutputZip = $OutputFile.Insert($OutputFile.Length,'.zip')
        Set-Content -Path $OutputZip -Value $Content -Encoding Byte
        Write-Host "[+] File '$($OutputZip)' created from clipboard value" -ForegroundColor Green
    } else {
            Write-Host "[-] You need to specify either an input or output file" -ForegroundColor Yellow
    }
}

# Base64 encode a file and copy the result to the clipboard (e.g. for transfering via RDP)
# Invoke-Base64FileCopy -InputFile C:\tools\sharphound.exe -Verbose

# Decode a base64 representation of file (exe, zip, ...) that's in your clipboard and write it to disk
# Invoke-Base64FileCopy -OutputFile C:\tools\sharphound.exe -Verbose
