# TEMPLATE commands: install

Shell scripts to build and install customized JOD Distribution into local dir.

For Bash:

```shell
$ bash scripts/install.sh [JOD_DIST_CONFIG_FILE] [INST_DIR]
```

For PowerShell:

```powershell
$ powershell scripts/install.ps1 [JOD_DIST_CONFIG_FILE] [INST_DIR]
```

## Description

This script builds the JOD Distribution (via [TMPL/build](build.md) command), then copy generated files into ```INST_DIR```. By default, ```INST_DIR``` is a random generated path following this pattern ```envs/$DIST_ARTIFACT-$DIST_VER/$4DIGIT_RANDOM_NUMBER```.
The JOD Distribution is build using ```JOD_DIST_CONFIG_FILE``` config file.

More info on ```JOD_DIST_CONFIG_FILE``` path and contents can be found at [TMPL/build command](build.md) documentation.

### Examples

From the $DIST_DIR use the default ```$DIST_DIR/configs/jod_dist_configs.sh``` file, and a random generated installation directory
```shell
$ bash scripts/install.sh
```

From everywhere use the default ```$DIST_DIR/configs/jod_dist_configs.sh``` file, and a random generated installation directory
```shell
$ bash $DIST_DIR/scripts/install.sh
```

From the $DIST_DIR use the ```$DIST_DIR/configs/jod_dist_test.sh``` configs, and ```env/dist_dir``` folder as installation directory
```shell
$ bash scripts/install.sh "configs/jod_dist_test.sh" "env/dist_dir"
```
