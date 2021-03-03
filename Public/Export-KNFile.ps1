<#
.SYNOPSIS
    Download system file from router
.DESCRIPTION
    Download device configuration as a text, which could be saved as configuration backup.
.EXAMPLE
    PS C:\> Export-KNFile -File firmware -Session $Keenetic_Giga -OutFile c:\fw_backup.bin
    Save firmware from router as c:\fw_backup.bin, using $Keenetic_Giga session
.EXAMPLE
    PS C:\> Export-KNFile running-config.txt
    Download running-config.txt from default session. Command-let will raise an exception if default session is not defined.
.NOTES
    General notes
.LINK
    https://github.com/ryzhovau/keenetic-powershell
#>
function Export-KNFile {
    [CmdletBinding()]
    param(
        # Keenetic file, like 'default-config.txt' or 'firmware'
        [ValidateSet('default-config.txt','startup-config.txt','running-config.txt','self-test.txt','firmware','log.txt')]
        [Parameter(Position=1,Mandatory=$true)]
        [string]$File,
        # Existing connection session. Default session used if parameter omitted.
        [KNSession]$Session=$Global:DefaultKNSession,
        # Specifies the output file to save instead of returning it to pipe. 
        [string]$OutFile=$File
    )
    Begin {
    }
    Process {
        Invoke-WebRequest -Uri "$($Session.Target)ci/$($File)" -Method Get -WebSession $Session.WebSession -ContentType 'application/octet-stream' -OutFile $OutFile | Out-Null
     }
    End {
    }
}
