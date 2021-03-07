<#
.SYNOPSIS
    Closes connection session
.DESCRIPTION
    Log out from router (and destroy session variable for default session).
.EXAMPLE
    PS C:\> Remove-KNSession -Session $Keenetic_Giga
    Log out from device. User defined session variable $Keenetic_Giga still remains available.
.EXAMPLE
    PS C:\> Remove-KNSession
    Log out from device and remove default session. Command-let will raise an exception if default session is not defined.
.LINK
    https://github.com/ryzhovau/keenetic-powershell
#>
function Remove-KNSession {
    [CmdletBinding()]
    param(
        # Existing connection session. Default session used if parameter omitted.
        [Parameter(ValueFromPipeline = $true)]
        [KNSession]$Session = $Global:DefaultKNSession
    )
    Begin {
        Invoke-WebRequest -Uri "$($Session.Target)auth" -WebSession $Session.WebSession -Method Delete -ContentType 'application/json' | Out-Null
        if ($session.Equals($Global:DefaultKNSession)) {
            Remove-Variable DefaultKNSession -Scope Global
        }
    }
    Process {
    }
    End {
    }
}
