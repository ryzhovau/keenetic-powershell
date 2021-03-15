<#
.SYNOPSIS
    POST/GET/DELETE requests to Keenetic REST API
.DESCRIPTION
    This is a prototype for any other requests exposed from module.
.EXAMPLE
    PS C:\> Invoke-KNRequest show/version -Session $Session
    Return a JSON response from 'show version' CLI command in active $session. 
.EXAMPLE
    PS C:\> Invoke-KNRequest 'firmware' -Ci -OutFile fw_backup.bin -Raw
    Download firmware via deprecated XML Core Interface (ci). Function will raise an exception if default session is not defined.
.LINK
    http://docs.help.keenetic.com/cli/3.1/en/cli_manual_kn-1010.pdf
#>
function Invoke-KNRequest {
    param(
        # Use deprecated 'ci' XML Core Interface. Otherwise, REST Core Interface 'rci' wil be used (by default).
        [switch]$Ci,
        # Request method. Post/Get/Delete methods allowed. 'Get' by default.
        [ValidateSet('Post','Get','Delete')]
        [string]$Method = 'Get',
        # POST request body. Optional for 'rci', mandatory for 'ci'.
        [string]$PostBody,   
        # URL, i.e. 'show/version'
        [Parameter(Position = 1)]
        [string]$URL,
        # Specifies the output file to save instead of returning it to pipe. 
        [string]$OutFile,
        # Don't try to interpret Keentic response as JSON/XML. 
        [switch]$Raw = $false,
        # Request headers
        [System.Collections.IDictionary]$Headers,
        # Existing connection session. Default session used if parameter omitted.
        [Parameter(ValueFromPipeline = $true)]
        [KNSession]$Session = $Global:DefaultKNSession 
    )
    Begin {
    }
    Process {
        if ($null -eq $Session) {
            throw [System.Exception] 'Neither -Session nor $DefaultKNSession provided.'
        }
        if ($ci) {
            $CoreInterface = 'ci'
            $ContentType = 'application/xml'
        } else {
            $CoreInterface = 'rci'
            $ContentType = 'application/json'
        }
        $Uri = '{0}{1}/{2}' -f $Session.Target,$CoreInterface,$URL
        if ($PostBody -ne '') {
            $Method = 'Post'
        }
        $RequestParams = @{
            Uri = $Uri
            Method  = $Method
            WebSession = $Session.WebSession
            ContentType = $ContentType
        }       
        if ($Method -eq 'Post') {
            $RequestParams['Body'] = $PostBody
        }
        if ($OutFile -ne '') {
            $RequestParams['OutFile'] = $OutFile
        }
        if ($Headers.Count -ne 0) {
            $RequestParams['Headers'] = $Headers
        }
        $RequestParams.GetEnumerator() | ForEach-Object {
            Write-Verbose "$($PSItem.Key) = $($PSItem.Value)"
        }
        if ($false -eq $Raw) {
            Invoke-RestMethod @RequestParams
        } else {
            Invoke-WebRequest @RequestParams
        }
    }
    End {
    }
}
