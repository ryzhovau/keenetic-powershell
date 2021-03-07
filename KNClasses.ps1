<#
This script is called from Keenetic.psm1 as `ScriptsToProcess = @('KNClasses.ps1')`
That's the way to expose public classes from module.

KNSession class:
- Stores session parameters,
- Can validate session.
#>
class KNSession {
    # Uri to connect, like http://192.168.0.1 or https://my.keentic.pro
    [System.Uri]$Target
    # Username and password. User must have 'http' tag.
    [pscredential]$Credential
    # Session variable to store session cookies.
    [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession
    # Can probe session for expiration.
    [bool]IsValid() {
        try {
            Write-Verbose "KNSession.IsValid(): probe $($this.Target)auth to find out session status."
            Invoke-WebRequest -Uri "$($this.Target)auth" -WebSession $this.WebSession  -ContentType 'application/json' | Out-Null
            return $true
        } catch {
            return $false
        }
    }
}

