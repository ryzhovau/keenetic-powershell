<#
This script is called from Keenetic.psm1 as `ScriptsToProcess = @('KNClasses.ps1')`
That's the way to expose public class from module.

KNSession class:
- Stores session parameters,
- Can validate session.
#>
class KNSession {
    [System.Uri]$Target
    [pscredential]$Credential
    [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession
    [bool]IsValid(){
        try {
            Invoke-WebRequest -Uri "$($this.Target)/auth" -WebSession $this.WebSession  -ContentType 'application/json' | Out-Null
            return $true
        } catch {
            return $false
        }
    }
}

