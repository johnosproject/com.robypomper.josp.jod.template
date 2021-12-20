# Distribution commands: state

Shell scripts to print the JOD instance state

For Bash:

```shell
$ bash state.sh [SHOW_ALL] [NO_LOGS]
```

For PowerShell:

```powershell
$ powershell state.ps1 [SHOW_ALL] [NO_LOGS]
```

## Description

This script query current JOD instance and print his info and status to the console.

Optionally this script allow two params:
* NO_LOGS: print only JOD instance values (default=false)
* SHOW_ALL: print also JOD related service/daemon status (installed or not) (default=false)

**NB:** this command is shell-sensible. That means, if you are working on a unix machine, then you can only run bash scripts. However, if you are working on a windows machine, then you can only run powershell scripts.


### Examples

Print JOD instance info for a JOD instance just installed (never executed).
```shell
$ bash state.sh
> INF: Get distribution statuses...
> Instance State:  NOT Running
> Instance PID:    N/A
> Obj's name:      ''
> Obj's id:        ''
> INF: Distribution state get successfully
```

Print JOD instance info for a running JOD instance.
```shell
$ bash state.sh
> INF: Get distribution statuses...
> Instance State:  Running
> Instance PID:    43445
> Obj's name:      Blackberry_07,
> Obj's id:        QTGBV-00000-00000,
> INF: Distribution state get successfully
```

Print all JOD instance info for a running JOD instance not installed as a service/daemon.
```shell
$ bash state.sh true true
> INF: Get distribution statuses...
> Password:             < enter sudo password
> Instance State:  Running
> Instance PID:    43445
> Is Installed:    Not Installed
> Obj's name:      Blackberry_07,
> Obj's id:        QTGBV-00000-00000,
> INF: Distribution state get successfully
```

Print only JOD instance info for a running JOD instance.
```shell
$ bash state.sh false true
> Password:
> Instance State:  Running
> Instance PID:    43445
> Obj's name:      Blackberry_07,
> Obj's id:        QTGBV-00000-00000,
```
