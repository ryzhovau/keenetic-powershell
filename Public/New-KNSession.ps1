<#
.SYNOPSIS
    Authentificate on Keenetic device and save session parameters
.DESCRIPTION
    Pass through auth challenge on given device and output result for future use.
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
function New-KNSession {
    [CmdletBinding()]
    [OutputType([KNSession])]
    param(
        # URL to connect, like 'http://192.168.0.1' or 'https://my.keenetic.pro'. Presumes 'http://my.keenetic.net' by default.
        [System.Uri]$Target = 'http://my.keenetic.net',
        # User name and password for target device. User must have 'http' tag to interact with core interface.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [pscredential]$Credential,
        # Store session parameters to $DefaultKNSession instead of returning object
        [Switch]$AsDefaultSession
    )
    Begin {
        function Get-Hash (
        [string]$String,
        [string]$Algo)
        {
            $HashEngine = [System.Security.Cryptography.HashAlgorithm]::create($algo)
            $UTF8 = New-Object -TypeName System.Text.UTF8Encoding
            [System.BitConverter]::ToString($HashEngine.ComputeHash($utf8.GetBytes($String))).ToLower().Replace('-', '')
        }
    }
    Process {
        try {
            # First, we should catch X-NDM-Challenge/X-NDM-Realm headers from 401 response
            Invoke-WebRequest -Uri "$($Target)auth" -SessionVariable WebSession | Out-Null
        } catch  [System.Net.WebException] {
            $Response = $_.Exception.Response
            If ($Response.StatusCode -ne 'Unauthorized') {
                throw [System.Net.WebException] "Unexpected status received.`n$($_.Exception)"
            }
            <# Challenge is to send POST request with following data
            {
                login: login,
                password: sha256(token + md5(login + ':' + realm + ':' + password))
            }
            #>
            $Token = $Response.Headers["X-NDM-Challenge"]
            $Realm = $Response.Headers["X-NDM-Realm"]
            Write-Verbose "X-NDM-Challenge header is $($Token)"
            Write-Verbose "X-NDM-Realm header is $($Realm)"
            $MD5Hash = Get-Hash "$($Credential.GetNetworkCredential().UserName):$($Realm):$($Credential.GetNetworkCredential().Password)" 'MD5'
            $SHA256Hash = Get-Hash "$($Token)$($MD5Hash)" 'SHA256'
            $PostBody = @{"login"=$Credential.GetNetworkCredential().UserName; "password"=$SHA256Hash} | ConvertTo-Json
            Write-Verbose "Challenge request body is:`n$($PostBody)"
            try {
                Invoke-WebRequest -Uri "$($Target)auth" -WebSession $WebSession -Method Post -Body $PostBody -ContentType 'application/json' | Out-Null
            } catch {
                throw [System.Net.WebException] "Logon failed.`n$($_.Exception)"
            }
            $KNSession = [KNSession]@{
                Target = $Target
                Credential = $Credential
                WebSession = $WebSession
            }
            if ($AsDefaultSession) {
                $Global:DefaultKNSession = $KNSession
            } else {
                return $KNSession
            }
        }
    }
    End {
    }
}
