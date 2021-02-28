<#
.SYNOPSIS
    List Keenetic users.
.DESCRIPTION
    Returns list of users with tags and NT/MD5-hashed passwords
.EXAMPLE
    PS C:\> Get-KNUsers -Session $Keenetic_Giga
    Show device users form $Keenetic_Giga session
.EXAMPLE
    PS C:\> Get-KNUsers
    Retrive device users from default session. Command let will raise an exception if default session is not defined.
.NOTES
    General notes
.LINK
    https://github.com/ryzhovau/keenetic-powershell
#>
function Get-KNUser {
    [CmdletBinding()]
    param(
        # Existing connection session. Default session used if parameter omitted.
        [Parameter(ValueFromPipeline=$true)]
        [KNSession]$Session=$Global:DefaultKNSession
    )
    Begin {
        $Users=(Invoke-GenericKNRequest -Endpoint 'rci/' -Method Post -PostBody '{"show":{"tags":{},"rc":{"user":{}}},"whoami":{}}' -Session $Session).show.rc.user
        return $Users
        <#
        foreach ($member in Get-Member -InputObject $Users -MemberType NoteProperty) {
            $Users.$member
        }
        #>
    }
    Process {
     }
    End {
    }
}
