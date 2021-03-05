<#
.SYNOPSIS
    POST/GET/DELETE requests to Keenetic REST API
.DESCRIPTION
    This is a prototype for any other requests exposed from module.
.LINK
    https://github.com/ryzhovau/keenetic-powershell
#>
function Invoke-GenericKNRequest {
    param(
         # API endpoint, i.e. 'rci/show/version'
        [Parameter(Mandatory = $true)]
        [string]$Endpoint,
        # Session object
        [Parameter(Mandatory = $true)]
        [KNSession]$Session,
        # Request method. Post/Get/Delete methods allowed
        [ValidateSet('Post','Get','Delete')]
        [Parameter(Mandatory = $true)]
        [string]$Method,
        # POST request body.
        [string]$PostBody
    )
    Begin {
    }
    Process {
         if ($null -eq $Session) {
            throw [System.Exception] 'Neither -Session nor $DefaultKNSession provided.'
        }
        Write-Verbose "Performing REST API request to $($Session.Target)$($Endpoint)"
        if ($null -eq $PostBody) {
            Invoke-RestMethod -Uri "$($Session.Target)$($Endpoint)" -Method $Method -WebSession $Session.WebSession -ContentType 'application/json'
        } else {
            Invoke-RestMethod -Uri "$($Session.Target)$($Endpoint)" -Method $Method -Body $PostBody -WebSession $Session.WebSession -ContentType 'application/json'
        }
    }
    End {
    }
}
