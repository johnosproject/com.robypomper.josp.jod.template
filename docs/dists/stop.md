# Distribution commands: stop

Shell scripts to stop the JOD instance

For Bash:

```shell
bash stop.sh
```

For PowerShell:

```shell
powershell stop.ps1
```

## Description

This script try to stop current JOD instance.

If the JOD instance is NOT running, then this command exit successfully.

**NB:** this command is shell-sensible. That means, if you are working on a unix machine, then you can only run bash scripts. However, if you are working on a windows machine, then you can only run powershell scripts.


### Examples

Stop JOD instance.
```shell
bash stop.sh
INF: Check if distribution is already stopped...
INF: Execute pre-shutdown.sh...
INF: Kill distribution...
INF: Wait 2 seconds and re-check...
INF: Check if distribution was stopped gracefully...
INF: Wait 3 seconds and re-check...
INF: Check if distribution was stopped gracefully...
INF: JOD shutdown successfully
INF: Execute post-shutdown.sh...
```

Error on stop JOD instance because NOT running.
```shell
bash stop.sh
INF: Check if distribution is already stopped...
WAR: Distribution already stopped, nothing to do
```
