<#
.SYNOPSIS
    Authentificate on Keenetic device and save session parameters.
.DESCRIPTION
    Process auth challenge on given device and output result for use in future.
    Please note about session expiration after few minutes of inactivity.
.EXAMPLE
    PS C:\> Get-Credential | New-KNSession -Target https://my.keenetic.com -AsDefaultSession
    Log onto Keenetic Router on given URL and credentials and save session parameters in memory for further use.
.EXAMPLE
    PS C:\>$Session = New-KNSession -Credential (Get-Credential)
    Log onto Keenetic Router on default address 'http://my.keenetic.net' and return session parameters as an object.
.NOTES
    General notes
.LINK
    https://github.com/ryzhovau/keenetic-powershell
#>
function Get-KNUsers {
    [CmdletBinding()]
    param(
        # Existing connection session
        [Parameter(ValueFromPipeline=$true)]
        [KNSession]$Session
    )
    Begin {
        (Invoke-GenericKNRequest -Endpoint 'rci/' -PostBody '{"show":{"tags":{},"rc":{"user":{}}},"whoami":{}}' -Session $Session).show.rc.user
    }
    Process {
     }
    End {
    }
}
