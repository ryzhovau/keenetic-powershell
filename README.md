# Keenetic PowerShell Module
This module allows to operate with [Keenetic routers](https://keenetic.com) router from command line. You can get or set WAN connections, LAN segments, Users, Services and other configurable options.

# Installation
```
Import-Module "path\to\keenetic.psd1
```

# Usage
```
$Session=Start-KNSession -Credentials (Get-Credentials)
Get-KNUsers -Session $Session
```
See [Wiki](https://github.com/ryzhovau/keenetic-powershell/wiki) for available commandlets with detailed description.
