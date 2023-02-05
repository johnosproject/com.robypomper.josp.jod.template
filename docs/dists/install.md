# Distribution commands: install

Shell scripts to install the JOD instance as service/daemon on local machine.

For Bash:

```shell
$ bash install.sh [FORCE]
```

For PowerShell:

```powershell
$ powershell install.ps1 [FORCE]
```

## Description

This script try to install current JOD instance as a service/daemon managed by local operating system (p.e.: run on boot).

If the JOD instance is already installed this command exit with the ```$ERR_ALREADY_INSTALLED``` error code. You can force this behaviour with the ```FORCE``` param: if it's set to ```true```, then the install script re-install the JOD instance on local operating system.

**NB:** this command is shell-sensible. That means, if you are working on a unix machine, then you can only run bash scripts. However, if you are working on a windows machine, then you can only run powershell scripts.

This command use ```scripts/init/$INIT_SYS/*``` sub-scripts to query, install and uninstall this JOD instance as a service/daemon. 

### Examples

Install JOD instance as a service/daemon on local operating system
```shell
$ bash install.sh
INF: Check if distribution is already installed...
Password:
INF: Execute pre-install.sh...
INF: Installing distribution...
INF: Set jod.sh as executable...
INF: Config and copy PLIST file...
INF: Installing distribution...
INF: Distribution installed successfully
INF: Execute post-install.sh...
```
