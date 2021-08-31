Function ConvertTo-GZipString () {
<#
  .SYNOPSIS
    Compresses a string with the GZip algorithm 
    
  .DESCRIPTION
    Compresses a string with the GZip algorithm and returns the result in a Base64 string
    
  .PARAMETER String
    Any plain text string to be compressed
    
  .EXAMPLE
    dir | Out-String | ConvertTo-GZipString
    
  .LINK
    ConvertFrom-GZipString
#>

  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
    $String
  )

  Process {
    $String | ForEach-Object {
      $ms = New-Object System.IO.MemoryStream
      $cs = New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionMode]::Compress)
      $sw = New-Object System.IO.StreamWriter($cs)
      $sw.Write($_)
      $sw.Close()
      [System.Convert]::ToBase64String($ms.ToArray())   
    }
  }
}
Function ConvertFrom-GZipString () {
<#
  .SYNOPSIS
    Decompresses a Base64 GZipped string
    
  .DESCRIPTION
    Decompresses a Base64 GZipped string
    
  .PARAMETER String
    A Base64 encoded GZipped string
    
  .EXAMPLE
    $compressedString | ConvertFrom-GZipString
    
  .LINK
    ConvertTo-GZipString
#>

  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
    $String
  )

  Process {
    $String | ForEach-Object {
      $compressedBytes = [System.Convert]::FromBase64String($_)
      $ms = New-Object System.IO.MemoryStream
      $ms.write($compressedBytes, 0, $compressedBytes.Length)
      $ms.Seek(0,0) | Out-Null
      $cs = New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionMode]::Decompress)
      $sr = New-Object System.IO.StreamReader($cs)
      $sr.ReadToEnd()
    }
  }
}
Function Invoke-Base64FileCopyPreparation {
    [CmdletBinding(DefaultParameterSetName = 'ToBase64')]
    param(
        [Parameter(Mandatory=$true,ParameterSetName='ToBase64')]
        [string]$InputFile,
        [Parameter(Mandatory=$true,ParameterSetName='FromBase64')]
        [string]$OutputFile,
        [Parameter(ParameterSetName='ToBase64')]
        [Parameter(ParameterSetName='FromBase64')]
        [switch]$CompressUsingZipFile
    )
    
    if ($InputFile.Length -gt 0) {
        if ($CompressUsingZipFile) {
            $TempFile = "$($env:TEMP)\Temp$(Get-Random -Minimum 100 -Maximum 999).zip"
            Compress-Archive -Path $InputFile -DestinationPath $TempFile | Out-Null
            $base64string = [Convert]::ToBase64String([IO.File]::ReadAllBytes($TempFile))
            Set-Clipboard -Value $base64string
            del $TempFile -Force | Out-Null
        } else {
            $base64string = [Convert]::ToBase64String([IO.File]::ReadAllBytes($InputFile))
            Set-Clipboard -Value (ConvertTo-GZipString -String $base64string)
        }
        Write-Host "[+] Compressed base64 representation of '$($InputFile)' copied to your clipboard." -ForegroundColor Green

    } elseif ($OutputFile.Length -gt 0) {
        if ($CompressUsingZipFile) {
            $OutputZip = $OutputFile.Insert($OutputFile.Length,".zip")
            Set-Content -Path $OutputZip -Value ([System.Convert]::FromBase64String((Get-Clipboard))) -Encoding Byte
        } else {
            try {
                Set-Content -Path $OutputFile -Value ([System.Convert]::FromBase64String((ConvertFrom-GZipString -String (Get-Clipboard) -ErrorAction Stop))) -Encoding Byte
                Write-Host "[+] File '$($OutputFile)' created from clipboard value" -ForegroundColor Green
            } catch {
                Write-Host "[-] Error uncompressing, base64 decoding and writing clipboard content to '$($OutputFile)'"
            }
        }
    } else {
            Write-Host "[-] You need to specify either an input or output file" -ForegroundColor Yellow
    }
}



#Invoke-Base64FileCopyPreparation -InputFile "C:\tools\kerbrute_windows_amd64.exe"
#Invoke-Base64FileCopyPreparation -OutputFile "C:\tools\kerbrute_windows_amd64_newer.exe"
