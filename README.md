# Keenetic PowerShell Module
This module allows to operate with [Keenetic routers](https://keenetic.com) from command line. You can get or set WAN connections, LAN segments, Users, Services and other configurable options.

# Installation
```
Import-Module "path\to\Keenetic.psd1"
```

# Usage
```
Start-KNSession -Credential (Get-Credentials) -AsDefaultSession
Get-KNUser
```
See [Wiki](https://github.com/ryzhovau/keenetic-powershell/wiki) for available commandlets with detailed description.

# Acknowledgment
Thanks to Sergey Mazepin and Rostislav Bronzov aka @Rostis1av for PowerShell course.
Thanks to Adam Driscoll aka @adamdriscoll for brilliant module skeleton from [selenium-powershell](https://github.com/adamdriscoll/selenium-powershell).
