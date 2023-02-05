# TEMPLATE commands: build

Shell scripts to build customized JOD Distribution.

For Bash:

```shell
$ bash scripts/build.sh [JOD_DIST_CONFIG_FILE]
```

For PowerShell:

```powershell
$ powershell scripts/build.ps1 [JOD_DIST_CONFIG_FILE]
```

## Description

This script assembles a JOD Distribution based on specified ```JOD_DIST_CONFIG_FILE``` file. By default, ```JOD_DIST_CONFIG_FILE```'s value is ```configs/jod_dist_configs.sh|ps1```.

The generated JOD Distribution is build in ```build/$DIST_ARTIFACT/$DIST_VER``` folder.

The ```JOD_DIST_CONFIG_FILE``` can be an absolute file path or a working dir relative path. Can be used also path relative to the distribution's project dir, for example the path 'configs/configs_test.sh' can be used also outside the $JOD_DIST_DIR folder.

### Examples

From the $DIST_DIR use the default ```$DIST_DIR/configs/jod_dist_configs.sh``` file
```shell
$ bash scripts/build.sh
```

From the $DIST_DIR use the ```$DIST_DIR/configs/jod_dist_test.sh``` configs
```shell
$ bash scripts/build.sh "configs/jod_dist_test.sh"
```

From everywhere use the ```$DIST_DIR/configs/jod_dist_test.sh``` configs
```shell
$ bash $DIST_DIR/scripts/build.sh "configs/jod_dist_test.sh"
```

From the $DIST_DIR  use the ```/home/user/jod_configs/jod_dist_XYZ.sh``` configs
```shell
$ bash scripts/build.sh "/home/user/jod_configs/jod_dist_XYZ.sh"
```

### Configs

The ```configs/jod_dist_configs.sh|ps1``` files contains all properties and can be used as starting point to configure the JOD custom Distribution build process. To use those files you must fill mandatory configs and then delete the 'customization checks' in the upper lines of the files (look for the '# Customize this file and then delete this line' comment).

JOD Distribution's configs groups:
* [JOD Distribution](#jod_distribution)
* [John Cloud Platform](#john_cloud_platform)
* [JOD Object](#jod_object)
* [JOD Firmware](#jod_firmware)

#### JOD Distribution

##### DIST_NAME

* **Mandatory:** ```true```
* **Default:** ```N/A```
* **Examples:** ```DIST_NAME="JOD My TEST Object"```, ```DIST_NAME="JOD {ProtocolName}"```

A string representing current JOD Distribution's name. Commonly prefixed with "JOD" string, must be human-readable.

##### DIST_ARTIFACT

* **Mandatory:** ```true```
* **Default:** ```N/A```
* **Examples:** ```DIST_ARTIFACT="JOD-MyDist"```

A string representing current JOD Distribution code. This string must be without spaces because it's used for artifact and dir names.

##### DIST_VER

* **Mandatory:** ```true```
* **Default:** ```N/A```
* **Examples:** ```DIST_VER="1.0"```

A custom string representing current JOD Distribution version.

#### John Cloud Platform

##### DIST_JCP_ID

* **Mandatory:** ```true```
* **Default:** ```N/A```
* **Examples:** ```DIST_JCP_ID="xxxx-xxxx-xxxx"```

JCP Environment Object's credentials id. A string containing the JCP client id for selected JCP Auth (depends on DIST_JCP_ENV). It's mandatory, if not set you can't build JOD Distribution.

##### DIST_JCP_SECRET

* **Mandatory:** ```true```
* **Default:** ```N/A```
* **Examples:** ```DIST_JCP_SECRET="xxxx-xxxx-xxxx"```

JCP Environment Object's credentials secret. A string containing the JCP client secret for selected JCP Auth (depends on DIST_JCP_ENV). It's mandatory, if not set you can't build JOD Distribution.

##### DIST_JCP_ENV

* **Mandatory:** ```false```
* **Default:** ```stage```
* **Examples:** ```DIST_JCP_ENV="prod"```

JCP Environment to use for JOD Distribution. A string from (local|stage|prod) set. This property allow build JOD Distributions with predefined JCP configs for local, stage or production JCP environments.

Depending on DIST_JCP_ENV value, different JCP urls are set in the 'jod.yml' file.
- local: set urls for a local JCP environment executed via the 'com.robypomper.josp' project
- stage: set urls for Public JCP - Stage environment (to use for pre-release tests)
- prod: set urls for Public JCP - Production environment  (to use for release build)

**NB:** This property can take effect only if in ```DIST_JOD_CONFIG_TMPL``` file there are the ```%DIST_JCP_ENV_XY%``` placeholders.

#### JOD Object

##### DIST_JOD_VER

* **Mandatory:** ```true```
* **Default:** ```N/A```
* **Examples:** ```DIST_JOD_VER="2.2.0"```

JOD Agent version to include in the generated distribution. The JOD agent's and his dependencies will be downloaded from central maven repository, if not available, then will be copied from local maven repository.

##### DIST_JOD_NAME

* **Mandatory:** ```false```
* **Default:** ```""```
* **Examples:** ```DIST_JOD_NAME="JOD My Object"```

The JOD Object's name.
A string used as JOD object's name. All instances of current JOD Distribution will have the same name. By default, (value = ```""```) it allows the JOD Agent to generate a new name for each JOD instance executed.

**NB:** This property can take effect only if in ```DIST_JOD_CONFIG_TMPL``` file there is the ```%DIST_JOD_NAME%``` placeholder.

##### DIST_JOD_ID

* **Mandatory:** ```false```
* **Default:** ```""```
* **Examples:** ```DIST_JOD_ID="XXXXX-XXXXX-XXXXX"```

The JOD Object's id     (WAR: do not use when releasing a JOD Distribution).
A string containing a predefined JOD Object's id in ```XXXXX-XXXXX-XXXXX``` format.
All instances of current JOD Distribution will have the same id. By default, (value = ```""```) it allows the JOD Agent to generate a new id for each JOD instance executed.

**NB:** This property can take effect only if in ```DIST_JOD_CONFIG_TMPL``` file there is the ```%DIST_JOD_ID%``` placeholder.

##### DIST_JOD_OWNER

* **Mandatory:** ```false```
* **Default:** ```"00000-00000-00000"```
* **Examples:** ```DIST_NAME="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"```

JOD Object's owner.
A string containing a predefined JOSP User's id in ```XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX``` format. All instances of current JOD Distribution will have the same owner. By default, (value = ```"00000-00000-00000"```) means no user is registered as owner, so other JOSP Users can register them self as object owners.

**NB:** This property can take effect only if in ```DIST_JOD_CONFIG_TMPL``` file there is the ```%DIST_JOD_OWNER%``` placeholder.

##### DIST_JOD_CONFIG_TMPL

* **Mandatory:** ```false```
* **Default:** ```"dists/configs/jod_TMPL.yml"```
* **Examples:** ```DIST_JOD_CONFIG_TMPL="dists/configs/jod_TMPL_test.yml"```

JOD Object's main config template.
A file path for an alternative JOD configs template file. By default, (value = "") use preconfigured ```$JOD_DIST_DIR/dists/configs/jod_TMPL.yml``` file.
The ```jod_TMPL.yml``` is the base file where all %VAR% are replaced with JOD Distribution's scripts configs values. For VARs complete list, see the '$JOD_DIST_DIR/scripts/build.sh' script or the ```jod_TMPL.yml``` file itself. 

The file path must be relative to the ```$JOD_DIST_DIR```.

##### DIST_JOD_CONFIG_LOGS_TMPL

* **Mandatory:** ```false```
* **Default:** ```"dists/configs/log4j2_TMPL.xml"```
* **Examples:** ```DIST_JOD_CONFIG_LOGS_TMPL="dists/configs/log4j2_TMPL_test.xml"```

JOD Object's logs config template.
A file path for an alternative '$JOD_DIST_DIR/dists/configs/log4j2_TMPL.xml' file. By default, (value = ```""```) use preconfigured ```$JOD_DIST_DIR/dists/configs/log4j2_TMPL.xml```file.

The ```log4j2_TMPL.xml``` is a Log4j2 config file used to print logs on console, on files, on network listeners...

The file path must be relative to the ```$JOD_DIST_DIR```.

##### DIST_JOD_STRUCT

* **Mandatory:** ```false```
* **Default:** ```"dists/configs/struct.jod"```
* **Examples:** ```DIST_JOD_STRUCT="dists/configs/struct_test.jod"```

JOD Object's structure files.
A file path for a valid ```struct.jod``` file to include in the built JOD Distribution. By default, (value = ```""```) use preconfigured ```$JOD_DIST_DIR/dists/configs/struct.jod``` file.

The file path must be relative to the ```$JOD_DIST_DIR```.

##### DIST_JOD_COMM_DIRECT_ENABLED

* **Mandatory:** ```false```
* **Default:** ```True```
* **Examples:** ```DIST_JOD_COMM_DIRECT_ENABLED="False"```

Enable/Disable JOD Local Communication, default true.

**NB:** This property can take effect only if in ```DIST_JOD_CONFIG_TMPL``` file there is the ```%DIST_JOD_COMM_DIRECT_ENABLED%``` placeholder.

##### DIST_JOD_COMM_CLOUD_ENABLED

* **Mandatory:** ```false```
* **Default:** ```True```
* **Examples:** ```DIST_JOD_COMM_CLOUD_ENABLED="False"```

Enable/Disable JOD Local Communication, default true.

**NB:** This property can take effect only if in ```DIST_JOD_CONFIG_TMPL``` file there is the ```%DIST_JOD_COMM_DIRECT_ENABLED%``` placeholder.

#### JOD Firmware

##### DIST_JOD_WORK_PULLERS

* **Mandatory:** ```false```
* **Default:** ```"shell://com.robypomper.josp.jod.executor.PullerShell http://com.robypomper.josp.jod.executor.impls.http.PullerHTTP"```
* **Examples:** ```DIST_JOD_WORK_PULLERS="http://com.example.jod.executors.MyPuller"```

JOD Object's pullers protocols.
A list of loadable JOD Pullers used in the struct.jod file. An empty list load default pullers protocols:
- "shell" as PullerShell (PullerUnixShell for DIST_JOD_VER=2.2.0)
- "http" as PullerHttp

The list must use following format: {PROTO_SHORTCUT}://{PULLER_CLASS}[ ...]

##### DIST_JOD_WORK_LISTENERS

* **Mandatory:** ```false```
* **Default:** ```"file://com.robypomper.josp.jod.executor.ListenerFiles"```
* **Examples:** ```DIST_JOD_WORK_LISTENERS="file://com.example.jod.executors.MyListener"```

JOD Object's listeners protocols.
A list of loadable JOD Listeners used in the struct.jod file. An empty list load default listeners protocols:
- "file" as ListenerFiles

The list must use following format: {PROTO_SHORTCUT}://{LISTENER_CLASS}[ ...]

##### DIST_JOD_WORK_EXECUTORS

* **Mandatory:** ```false```
* **Default:** ```"shell://com.robypomper.josp.jod.executor.ExecutorShell file://com.robypomper.josp.jod.executor.ExecutorFiles http://com.robypomper.josp.jod.executor.impls.http.ExecutorHTTP"```
* **Examples:** ```DIST_JOD_WORK_EXECUTORS="shell://com.example.jod.executors.MyExecutor"```

JOD Object's executors protocols.
A list of loadable JOD Executors used in the struct.jod file. An empty list load default executors protocols:
- "shell" as ExecutorShell (ExecutorUnixShell for DIST_JOD_VER=2.2.0)
- "file" as ExecutorFile
- "http" as ExecutorHTTP

The list must use following format: {PROTO_SHORTCUT}://{EXECUTOR_CLASS}[ ...]

