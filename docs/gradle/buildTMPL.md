# Gradle: buildTMPL

Gradle's task to build the JOD Distribution TEMPLATE.

```shell
$ ./gradlew buildTMPL
```

## Description

This task copy files from different directory of the JOD Distribution TEMPLATE source code and put them in the ```build/assemble/$JOD_DIST_TMPL_VER``` dir. Resulting with a directory containing the built JOD Distribution TEMPLATE. **Tip:** During development process you can use this folder to test template's changes.<br>
Source dirs can be parted in 2 groups:
* TMPL: files used for JOD Distribution generation
* DISTS: files to be included in the JOD Distribution

### Source dirs for the build process

#### TMPL/Scripts

* **From:** ```src/tmpl/bash```, ```src/tmpl/ps```
* **Into:** ```build/assemble/$JOD_DIST_TMPL_VER/scripts```

Scripts for template's commands (build, publish) for Bash and Powershell, it also includes all scripts dependencies such as 'Robypomper Bash|Powershell Utils' and specific template's scripts.

#### TMPL/Configs

* **From:** ```src/tmpl/configs```
* **Into:** ```build/assemble/$JOD_DIST_TMPL_VER/configs```

Config files for the JOD Distribution build process. It's used by makers to set distribution info like name, version, etc... It's also used to store the JOD version and the JCP credentials to include in the distribution.

#### TMPL/Resources

* **From:** ```src/tmpl/resources```
* **Into:** ```build/assemble/$JOD_DIST_TMPL_VER/```

Template resources are all static file that must be copied in the JOD Distribution TEMPLATE release, like the README.md, .gitignore or other files required by the building template.

#### DISTS/Scripts

* **From:** ```src/dists/bash```, ```src/dists/ps```
* **Into:** ```build/assemble/$JOD_DIST_TMPL_VER/dists/scripts```

Scripts for distribution's commands (state, start/stop, install/uninstall) for Bash and Powershell, it also includes all scripts dependencies such as 'Robypomper Bash|Powershell Utils', specific distribution's scripts and 'init systems' scripts.

#### DISTS/Configs

* **From:** ```src/dists/configs```
* **Into:** ```build/assemble/$JOD_DIST_TMPL_VER/dists/configs```

Config files for the JOD Distribution execution. It's used by end users to set JOD configs like JAVA_HOME or JOD_YML.

#### DISTS/Resources

* **From:** ```src/dists/resources```<br>
* **Into:** ```build/assemble/$JOD_DIST_TMPL_VER/dists/resources```

Distribution resources are all static file that must be copied in the JOD Distribution build process. It includes a set of ```*_EXMPL``` files that can be renamed and customize by makers, not needed example files can be removed.
