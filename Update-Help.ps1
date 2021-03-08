# Install-Module -Name platyPS
Import-Module platyPS
Import-Module Keenetic -Force

# New-MarkdownHelp -Module keenetic -NoMetadata -WithModulePage -ModulePagePath keenetic-wiki\Home.md -OutputFolder keenetic-wiki  -Force
Update-MarkdownHelpModule -Path keenetic-wiki -ModulePagePath keenetic-wiki\Home.md
