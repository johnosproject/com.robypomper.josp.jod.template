# JOD Distribution commands

The JOD Distribution is a directory containing various files already configured to execute a JOSP Object. So, when a JOD Distribution's files are copied in to the target machine/directory, this directory become a JOD instance that can be executed or installed as a background service or daemon (depending on target machine os). 

It provides a set of scripts to automate the JOD instance management.

* [state](state.md): print the JOD instance state
* [start](start.md): start current JOD instance
* [stop](stop.md): stop current JOD instance
* [install](install.md): install current JOD instance as a service/daemon
* [uninstall](uninstall.md): uninstall current JOD instance as a service/daemon

All JOD Distribution commands are shell-sensible. That means, if you are working on a unix machine, then you can only run bash scripts. However, if you are working on a windows machine, then you can only run powershell scripts.

## Supported Init Systems

Depending on local machine's operating system, the JOD Distribution commands can support different Init System:
* InitSystem_TMPL (not working, it's a template)
* LaunchD
* SystemD
* SysV (not working)
* Upstart (not working)
* WinInitSys

## PRE-POST Scripts

The JOD Distribution commands use extra scripts to customize each action on the JOD Instance. Those scripts, if exists, are executed before (pre) and after (post) JOD instance actions: start, stop, install and uninstall. With those scripts, makers can customize certain JOD instance action like the startup, for example to setup the HW to communicate with.

In the JOD Distribution TEMPLATE you can find examples for all PRE/POST scripts.  

Here the list of all PRE/POST scripts:
- pre-startup.(sh|ps1)
- post-startup.(sh|ps1)
- pre-shutdown.(sh|ps1)
- post-shutdown.(sh|ps1)
- pre-install.(sh|ps1)
- post-install.(sh|ps1)
- pre-uninstall.(sh|ps1)
- post-uninstall.(sh|ps1)
