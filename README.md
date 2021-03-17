# Keenetic PowerShell Module
This module allows to operate with [Keenetic routers](https://keenetic.com) from command line. You can get or set WAN connections, LAN segments, Users, Services and other configurable options.


[![asciicast](https://asciinema.org/a/399922.svg)](https://asciinema.org/a/399922)

# Installation
```
Import-Module "path\to\Keenetic.psd1"
```

# Usage
```PowerShell
# Connect to default device via http://my.keenetic.net
Start-KNSession -Credential (Get-Credentials) -AsDefaultSession

# Run 'show version' CLI command via REST Core Interface (rci):
Invoke-KNRequest show/version

release      : 3.05.C.6.0-0
sandbox      : stable
title        : 3.5.6
…
manufacturer : Keenetic Ltd.
vendor       : Keenetic
series       : KN
model        : Ultra (KN-1810)
hw_version   : 10188000
hw_id        : KN-1810
device       : Ultra
region       : RU
description  : mykeenetic

# Download firmware, using deprecated XML Core Interface (ci):
Invoke-KNRequest 'firmware' -Ci -OutFile fw_backup.bin -Raw

# Pure CLI commands with autocompletion:
Invoke-KNCommand 'interface FastEthernet0/0 down' | ConvertTo-Json
{
    "parse":  {
                  "prompt":  "(config)",
                  "status":  [
                                 "@{status=message; code=72155142; ident=Network::Interface::Base; source=; warning=no;
 message=\"FastEthernet0/0\": interface is down.}"
                             ]
              }
}
```
See [Wiki](https://github.com/ryzhovau/keenetic-powershell/wiki) for available cmdlets with detailed description.

# Acknowledgment
Thanks to Sergey Mazepin and Rostislav Bronzov aka @Rostis1av for PowerShell course.

Thanks to Adam Driscoll aka @adamdriscoll for brilliant module skeleton from [selenium-powershell](https://github.com/adamdriscoll/selenium-powershell).
