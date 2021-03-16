<#
.SYNOPSIS
    Run CLI command just like SSH/Telnet console
.DESCRIPTION
    CLI emulator with autocomplete support
.EXAMPLE
    PS C:\> Invoke-KNCommand 'show version'
    Return 'show version' result as appropriate CLI command do
.LINK
    https://github.com/ryzhovau/keenetic-powershell
#>
function Invoke-KNCommand {
    param (
        # Existing connection session. Default session used if parameter omitted.
        [Parameter(ValueFromPipeline = $true)]
        [KNSession]$Session = $Global:DefaultKNSession,
        # CLI command, i.e. 'show version'
        [Parameter(Position = 1)]
        [ArgumentCompleter({
            param (
                $CommandName,
                $ParameterName,
                $WordToComplete,
                $CommandAst,
                $FakeBoundParameters
            )
            # We should return one string with quotation marks, that's the way to keep CLI command with all arguments
            # as the one PS function parameter. Without quotations 'show version' will be interpreted by PS as two parameters.

            # Feed RCI with no quotation marks, remove them if necessary
            if ($WordToComplete.StartsWith("'")) {
                $WordToComplete = $WordToComplete.Split("'")[1]
            }
            $Body = '{{"help": "{0}"}}' -f $WordToComplete
            if ($fakeBoundParameters.ContainsKey('Session')) {
                $Response = Invoke-KNRequest -Body $Body -Session $fakeBoundParameters.Session
            } else {
                $Response = Invoke-KNRequest -Body $Body
            }
            # .completion tells the only option left to complete command and/or option(s)
            if ($Response.help.completion) {
                "'" + $WordToComplete + $Response.help.completion + "'"
            } else {
                # No spaces means it's a part of command
                if (-not $WordToComplete.Contains(' ')) {
                    $Response.help.command.psobject.Properties | ForEach-Object {
                        "'" + $PSItem.Name + "'"
                    }
                # Space(s) present, which means CLI command with (half of) argument(s)
                } else {
                    # CLI command with arguments, complete wherever is possible, both from .command or .choice
                    if ($Response.help.command) {
                        $Response.help.command.psobject.Properties | ForEach-Object {
                            "'" + $WordToComplete + $PSItem.Name + "'"
                        }
                    } elseif ($Response.help.choice) {
                        $Response.help.choice | ForEach-Object {
                            "'" + $WordToComplete + $PSItem + "'"
                        }
                    }   
                }
            }
        })]
        [string]$Command
    )
    Begin {
        if ($null -eq $Session) {
            throw [System.Exception] 'Neither -Session nor $DefaultKNSession provided.'
        }
    }
    Process {
        $Body = '{{"parse": "{0}"}}' -f $Command
        $Body > debug.txt
        Invoke-KNRequest -Body $Body -Session $Session
    }
    End {
    }
}