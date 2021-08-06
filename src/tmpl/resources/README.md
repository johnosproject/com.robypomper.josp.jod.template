# JOD Distribution TEMPLATE - 1.0-DEV

The JOD Distribution TEMPLATE helps Makers to generates custom JOD Distributions
that can be executed on the local machine, deployed on remote objects or shared
with other users.

A JOD Distribution can be generated from scratch simply with following steps
1. [configure](#configure)
1. [build](#build)
1. [install and test](#install)


## Configure

If you haven't already, download and extract the JOD Distribution TEMPLATE from
the [JOSP Docs](https://www.johnosproject.org/docs/index.html) website.

```shell
$ curl -fo JOD_Dist_TMPL-{VER}.tgz \
      https://www.johnosproject.org/docs/References/JOD_Dists/JOD_Dist_TEMPLATE/JOD_Dist_TMPL-{VER}.tgz
$ tar zxvf JOD_Dist_TMPL-{VER}.tgz
$ mv JOD_Dist_TMPL-{VER} {MY_JOD_DIST}
```

Now you can edit {MY_JOD_DIST} files to your needs. More info on
[JOD Distribution TEMPLATE > Configure @ JOSP Docs](https://www.johnosproject.org/docs/References/JOD_Dists/JOD_Dist_TEMPLATE/configure).

```shell
$ cd {MY_JOD_DIST}

// Configure JOD Distribution build's configs, JOD Instance configs and object structure
$ nano configs/configs.sh
$ nano dists/configs/jod.yml
$ nano dists/configs/struct.jod

// Enable and customize PRE-POST scripts
$ cd dists/resources/scripts/
$ mv (pre|post)-*.sh_EXMPL (pre|post)-*.sh && nano (pre|post)-*.sh

// Add firmware files
$ cp {FIRMWARE_FILES} dists/resources/scripts/hw

// Add extra files and docs
$ cp {EXTRA_FILES} dists/resources/
$ mv log4j2.xml_EXMPL log4j2.xml && nano log4j2.xml
$ mv README.md_EXMPL README.md && nano README.md
$ cp {EXTRA_FILES} dists/resources/
```


## Build

Once you configured the your JOD Distribution, you can build it with following
Gradle task:

```shell
$ bash scripts/build.sh
```

To use a different JOD Distribution's config other than default 'configs/configs.sh'
please pass the config's file path as first param.

```shell
$ bash scripts/build.sh configs/configs_test.sh
```

Built JOD Distribution can be found in the ```build/$DEST_ARTIFACT/$DEST_VER```
directory.


## Install

The JOD Distribution installation, in this context, means copy built
JOD Distribution's files in another directory with the purpose to create a
working copy of built JOD Distribution. Because of that, after installation,
you can execute JOD Distribution's scripts in the installed folder and
manage that specific JOD Instance.

```shell
$ bash scripts/install.sh
```

Prev command, install ```configs/configs.sh```'s JOD Distribution to
```env/XXXX``` directory. Where 'XXXX' can be any 4-digit number. To specify
different JOD Distribution's configs file or installation dir, please use
```install.sh``` params.

```shell
$ bash scripts/install.sh configs/configs.sh envs/my-jod-object
```
