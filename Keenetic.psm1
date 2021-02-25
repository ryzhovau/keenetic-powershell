# Taken from https://github.com/adamdriscoll/selenium-powershell/blob/master/Selenium.psm1
$functionFolders = @('Public', 'Internal')

#. (Join-Path -Path $PSScriptRoot -ChildPath 'Internal/init.ps1')
ForEach ($folder in $functionFolders) {
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
    
    If (Test-Path -Path $folderPath) {
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1' 
        ForEach ($function in $functions) {
            . $($function.FullName)
        }
    }    
}

$publicFunctions = (Get-ChildItem -Path "$PSScriptRoot\Public" -Filter '*.ps1').BaseName
Export-ModuleMember -Function $publicFunctions
