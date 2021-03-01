# Install-Module -Name platyPS
Import-Module platyPS
# New-MarkdownHelp -Module Keenetic -OutputFolder .\keenetic-wiki
# New-ExternalHelp .\keenetic-wiki -OutputPath en-US\

Import-Module Keenetic -Force
Update-MarkdownHelp .\keenetic-wiki
