Function Invoke-Base64FileCopy {
    [CmdletBinding(DefaultParameterSetName = 'ToBase64')]
    param(
        [Parameter(Mandatory=$true,ParameterSetName='ToBase64')]
        [string]$InputFile,
        [Parameter(ParameterSetName='FromBase64')]
        [string]$OutputFile,
        [Parameter(ParameterSetName='FromBase64')]
        [switch]$ConvertFromBase64
    )
    
    if (-not ($ConvertFromBase64)) {
        $base64string = [Convert]::ToBase64String([IO.File]::ReadAllBytes($InputFile))
        Set-Clipboard -Value $base64string
        Write-Host "[+] Base64 representation of '$($InputFile)' copied to your clipboard." -ForegroundColor Green
    } else {
        try {
            $Content = [System.Convert]::FromBase64String((Get-Clipboard -ErrorAction Stop))
        } catch {
            Write-Host "[-] Error converting base64 string from clipboard value" -ForegroundColor Red
        }
        Set-Content -Path $OutputFile -Value $Content -Encoding Byte
        Write-Host "[+] File '$($OutputFile)' created from clipboard value" -ForegroundColor Green
    }
}

# Base64 encode a file and copy the result to the clipboard (e.g. for transfering via RDP)
# Invoke-Base64FileCopy -InputFile C:\tools\sharphound.exe -Verbose

# Decode a base64 representation of file (exe, zip, ...) that's in your clipboard and write it to disk
# Invoke-Base64FileCopy -OutputFile C:\tools\sharphound.exe -Verbose
