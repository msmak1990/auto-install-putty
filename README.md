# auto-install-putty
Date | Modified by | Remarks
:----: | :----: | :----
2021-02-13 | Sukri | Created
2021-02-13 | Sukri | Made some cosmetic changes on README.md
---

## Description:
> * This is the PowerShell script to install **silently** the Putty binary by getting the latest version from its official site. 
> * All done by automated way!.

Windows Version | OS Architecture | PowerShell Version | Result
:----: | :----: | :----: | :----
Windows 10 | 64-bit and 32-bit | 5.1.x | Tested. `OK`
---

### Below are steps on what script does:

No. | Steps
:----: | :----
1 | Get the configuration value from `Install-Putty.cfg.ini` i.e. the Putty source installer URL
2 | Pre-validate to check for the PuTTY availability in the target system
3 | Display on console if the PuTTY application available in the target system
4 | Download the latest version of PuTTY application from its official site
5 | Install **silently** the PuTTY application
6 | Post-validate to check if the PuTTY application installed successfully
---  

### How to run this script.

1. After cloning the repository, navigate into the base directory e.g. `..\auto-install-putty\`
2. Double-click on **`Install-Putty.cmd`** file optionally with an administration right
---

### There are some functions involved as follows:

No. | Function Name | Description
:----: | :---- | :----
1 | `Get-IniConfiguration` | This function is used to get the contents of the .ini configuration file
2 | `Get-ConfigurationValue` | This function is used to get the configuration value(s) from `Get-IniConfiguration` function
3 | `Get-Putty` | This function is used to the existence of Putty application in the target system
4 | `Get-OSArchitecture` | This function is used to check the OS architecture (64 or 32-bit) in the target system
5 | `Get-PuttyBinary` | This function is used to download the latest PuTTY installer from its official site
6 | `Install-Putty` | This function is used to install silently the PuTTY application by downloading the latest version its official site
4 | `Install-Putty.cfg.ini` | This is the configuration file to customize a few configuration values

---
Example for the configuration file i.e. `Install-Putty.cfg.ini`

```ini
[Install-Putty.ps1]
PUTTY_SOURCE_INSTALLER_PATH = https://the.earth.li/~sgtatham/putty/latest/
```