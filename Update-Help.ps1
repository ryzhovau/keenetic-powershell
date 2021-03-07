# Install-Module -Name platyPS
Import-Module platyPS
Import-Module Keenetic -Force

# New-MarkdownHelp -Module keenetic -NoMetadata -ModulePagePath "keenetic-wiki\README.MD" -OutputFolder .\keenetic-wiki -Force
Update-MarkdownHelpModule -Path en-us -ModulePagePath "keenetic-wiki\README.MD" -RefreshModulePage -Verbose
# Update-MarkdownHelp .\keenetic-wiki
