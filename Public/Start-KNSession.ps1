<#
.SYNOPSIS
    Authentificate on Keenetic device and save session parameters.
.DESCRIPTION
    Process auth challenge on given device and output result for use in future.
    Please note about session expiration after few minutes of inactivity.
.EXAMPLE
    PS C:\> Start-KNSession -URL https://thisismy.keenetic.com -AsDefaultSession -username vpnuser -password P@ssw0rd
    Log onto Keenetic Router on given URL using given credentials and save session parameter in memory for further use.
.EXAMPLE
    PS C:\> Start-KNSession -password P@ssw0rd
    Log onto Keenetic Router on default address 'http://my.keenetic.net', using default 'admin' username and return session parameters as an object.
.INPUTS
    Inputs (if any)
.OUTPUTS
    Session parameters like device address and request header for further Keenetic API requests
.NOTES
    General notes
.LINK

#>
function Start-KNSession {
    [CmdletBinding()]
    param(
        
    )
    Process {
        Write-Verbose "'Start-KNSEssion' called"
    }
}