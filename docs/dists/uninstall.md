# Distribution commands: uninstall

Shell scripts to uninstall the JOD instance as service/daemon on local machine.

For Bash:

```shell
$ bash uninstall.sh
```

For PowerShell:

```powershell
$ powershell uninstall.ps1
```

## Description

This script try to uninstall current JOD instance from local operating system as a service/daemon.

If the JOD instance is NOT installed this command exit successfully.

**NB:** this command is shell-sensible. That means, if you are working on a unix machine, then you can only run bash scripts. However, if you are working on a windows machine, then you can only run powershell scripts.

This command use ```scripts/init/$INIT_SYS/*``` sub-scripts to query, install and uninstall this JOD instance as a service/daemon. 

### Examples

Install JOD instance as a service/daemon on local operating system
```shell
$ bash uninstall.sh
INF: Check if distribution is already uninstalled...
Password:
INF: Execute pre-uninstall.sh...
INF: Uninstalling distribution...
INF: Uninstalling distribution...
INF: Removing PLIST file...
INF: Distribution uninstalled successfully
INF: Execute post-uninstall.sh...
```
