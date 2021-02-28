<#
.SYNOPSIS
    POST/GET requests to Keenetic REST API.
.DESCRIPTION
    This is a prototype for any other requests exposed from module
.LINK
    https://github.com/ryzhovau/keenetic-powershell
#>
function Invoke-GenericKNRequest {
    param(
         # API endpoint, i.e. 'rci/show/version'
        [Parameter(Mandatory=$true)]
        [string]$Endpoint,
        # Session object. Use $DefaultKNSession if omitted. 
        [KNSession]$Session,
        # POST request body. GET request will be performed if omitted
        [string]$PostBody
    )
    Begin {
    }
    Process {
        if ($null -eq $Session) {
            $Session=$Global:DefaultKNSession
        }
        if ($null -eq $Session) {
            throw [System.Exception] 'Neither -Session nor $DefaultKNSession provided.'
        }
        Write-Verbose "Performing REST API request to $($Session.Target)$($Endpoint)"
        if ($null -eq $PostBody) {
            Write-Verbose "POST body is $PostBody"
            Invoke-RestMethod -Uri "$($Session.Target)$($Endpoint)" -Method Get -WebSession $Session.WebSession -ContentType 'application/json'
        } else {
            Invoke-RestMethod -Uri "$($Session.Target)$($Endpoint)" -Method Post -Body $PostBody -WebSession $Session.WebSession -ContentType 'application/json'
        }
    }
    End {
    }
}
