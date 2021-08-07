# JOD Distribution TEMPLATE

**Source code project of the JOD Distribution TEMPLATE.**

The JOD Distribution TEMPLATE helps Makers to generates custom JOD Distributions
that can be executed on the local machine, deployed on remote objects or shared
with other users.

<table>
  <tr><th>Current version</th><td>1.0-DEV</td></tr>
  <tr><th>References</th><td><a href="https://www.johnosproject.org/docs/References/JOD_Dists/JOD_Dist_TEMPLATE/Home">JOD_Dist_TEMPLATE @ JOSP Docs</a></td></tr>
  <tr><th>Repository</th><td><a href="https://bitbucket.org/johnosproject_shared/com.robypomper.josp.jod.template/">com.robypomper.josp.jod.template @ Bitbucket</a></td></tr>
  <tr><th>Downloads</th><td><a href="https://bitbucket.org/johnosproject_shared/com.robypomper.josp.jod.template/downloads/">com.robypomper.josp.jod.template > Downloads @ Bitbucket</a></td></tr>
</table>

This project is based on Gradle and can build a JOD Distribution TEMPLATE
distributions. Then makers can download those distributions and use them as
starting point for their custom JOD Distributions.

----

## Building JOD Distribution TEMPLATE

This Gradle project provides tasks to build 'JOD Distribution TEMPLATE'
distributions. Once it was build, you can find the built files in the
```build/assemble/$JOD_TEMPL_VER``` dir, or in the ```build/publications```
folder as compressed files. The ```$JOD_TEMPL_VER``` value can be set updating
the ```project.ext.set('version.deps.josp.jod.template','{NEW_VERSION}')``` line
in the ```build.gradle``` file.

Here the Gradle task to build the JOD Distribution TEMPLATE:

```shell
$ ./gradlew buildTMPL
```

This task, clean destination directory and then start assembling the
JOD Distribution TEMPLATE files. Finally, it compresses built files.

Files that compose a JOD Distribution TEMPLATE can part in two groups: builders
and distribution files. The first group contains all scripts required to generate
the customized JOD Distribution. On the other hand, the second file's group
is copied into the resulting JOD Distribution, the ```resources``` folder can
be edited by the Maker to add/remove files on the JOD Distribution. 

**Builders files:**
* Scripts: scripts required to build the custom JOD Distribution
* Configs: configs for builder's scripts
* README.md: JOD Distribution Template's readme file

**Distribution files:**
* Scripts: scripts used to manage the JOD Instance (the installed copy of a JOD Distribution)
* Configs: default and examples configs files for distributions scripts
* Resources: customizable files that will be included into the custom JOD Distribution

----

## Building JOD Distribution (from JOD Distribution TEMPLATE)

After build or download the JOD Distribution Template, you can start customizing
it to generate your own JOD Distribution. 

1. Download, extract and rename JOD Distribution TEMPLATE
   ```shell
   $ curl -fo JOD_Dist_TMPL-{VER}.tgz \
          https://www.johnosproject.org/docs/References/JOD_Dists/JOD_Dist_TEMPLATE/JOD_Dist_TMPL-{VER}.tgz
   $ tar zxvf JOD_Dist_TMPL-{VER}.tgz
   $ mv JOD_Dist_TMPL-{VER} {MY_JOD_DIST}
   ```
1. Customizing the JOD Distribution <br/>
   More info on [JOD Distribution TEMPLATE > Configure @ JOSP Docs](https://www.johnosproject.org/docs/References/JOD_Dists/JOD_Dist_TEMPLATE/configure).
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
1. Build and install the JOD Distribution
   ```shell
   $ bash scripts/build.sh configs/configs.sh
   $ bash scripts/install.sh configs/configs.sh envs/my-jod-object
   ```
