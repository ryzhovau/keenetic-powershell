<#
.SYNOPSIS
    Decode NS3 password string
.DESCRIPTION
    Retrive plain text password from NDM Secure v3 (NS3) string. Get PPP/WPA password from config and pass it to this cmdlet.
.EXAMPLE
    PS C:\> ConvertFrom-NS3 -NS3String 'ClkGVb4VylHfkHQBQAg2jSUN'
    1357924680
    
.NOTES
    General notes
.LINK
    https://github.com/ryzhovau/keenetic-powershell
    https://antichat.com/threads/426200/#post-4008965
#>
function ConvertFrom-NS3 {
    [CmdletBinding()]
    param(
        # NS3 string from Keenetic config
        [Parameter(ValueFromPipeline=$true,Position=1,Mandatory=$true)]
        [String]$NS3String
    )
    Begin {
     }
    Process {
        While (-not (0 -eq $NS3String.Length % 4)) {
            $NS3String += '='
        }
        $Password = [System.Collections.Generic.List[byte]][System.Convert]::FromBase64String($NS3String)
        $Length=$Password.Count
        if ($Length -notin 0x12, 0x24, 0x48) {
            throw 'Invalid NS3 string length.'
        }
        
        [byte]$a2 = $Length / 8
        $x2 = $Password[$a2]
        $Password.RemoveAt($a2) | Out-Null
        
        [byte]$a1 = $x2 % ($Length - 1)
        $x1 = $Password[$a1]
        $Password.RemoveAt($a1) | Out-Null
        
        $x = 0
        foreach ($Byte in $Password) {
            $x = $x -bxor $Byte
        }
        for ($i = 1; $i -le 7; $i++) {
            $a = ((($x -shr $i) -bxor ((-bnot $x) -shl $i))) -band 0xff
            $x = ((($a -shl $i) -bxor ((-bnot $a) -bxor $x))) -band 0xff
        }
        for ($i = 0; $i -lt $Password.Count; $i++) {
            $Password[$i] = $Password[$i] -bxor $x
        }
        
        $x1 = $x1 -band 0xff
        $x2 = $x2 -band 0xff
        for ($i = 0; $i -lt $Password.Count; $i++) {
            $Password[$i] = $Password[$i] -bxor $x2
            $x = $x1
            $x1 = $x2
            $x2 = ($x + $x2) -band 0xff
        }
        
        $ZeroIndex = $Password.IndexOf(0)
        if ($ZeroIndex -ne -1) {
            $Length = $ZeroIndex
        } else {
            $Length = $Password.Count
        }
        return [System.Text.Encoding]::ASCII.GetString($Password.GetRange(0,$Length))
    }
    End {
    }
}
