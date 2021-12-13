# Gradle project

The Gradle project provide tasks to build and publish the JOD Distribution TEMPLATE.

---

## Gradle's tasks

This gradle configs provide 3 main tasks:
* [buildTMPL](buildTMPL.md): build the JOD Distribution TEMPLATE
* [publishTMPL](publishTMPL.md): build and publish the JOD Distribution TEMPLATE
* clean: remove all generated files

Here the complete tasks map:

```
TASK NAME              DEPENDS ON
---------------------- ----------------------
publishTMPL         -> [buildTMPL]
buildTMPL           -> cleanAssemble
                    -> [assembleTMPL], [assembleTMPLDists]
                    -> buildZip, buildTar
assembleTMPL        -> assembleTMPLScripts, assembleTMPLConfigs, assembleTMPLResources
assembleTMPLDists   -> assembleTMPLDistsScripts, assembleTMPLDistsConfigs, assembleTMPLDistsResources
clean
```

---

## Manage gradle configs

### Config JOD Distribution TEMPLATE's version

In the ```gradle.build``` file contain the ```version.deps.josp.jod.template``` property that define the JOD Distribution TEMPLATE's version for the build system. When update this value, remember to change also the version field in any ```*.sh``` file's and in the ```src/tmpls/docs/README.txt``` file.

### Handle hidden files

Gradle's task Copy can't copy hidden files (```.{filename}```), so replace the dot (```.```) with a unserline (```_```). Then add the 'rename' rule in corresponding gradle's task. 
    
Example for ```.gitignore``` file in TMPL resource:
```groovy
task assembleTMPLResources(type: Copy) {
    def version = project.ext.get('version.deps.josp.jod.template')

    from 'src/tmpl/resources'
    rename { filename ->
        filename.replace '_gitignore', '.gitignore'
    }

    into layout.buildDirectory.dir("assemble/$version")

    mustRunAfter cleanAssemble
}
```

### Development testing

When develop the JOD Distribution TEMPLATE commonly should use a combination of command to test your changes. For example if you would test JOD Template's scripts then you must build the gradle project's and then start the build script from generated JOD Distribution TEMPLATE. That can be handled with following commands:

```
# To test JOD Distribution TEMPLATE scripts
./gradlew buildTMPL && \
    bash build/assemble/$JOD_DIST_TEMPLATE_VER/scripts/build.sh configs/jod_dist_configs-DEV.sh

# To test JOD Distribution scripts
./gradlew buildTMPL && \
    bash build/assemble/$JOD_DIST_TEMPLATE_VER/scripts/build.sh configs/jod_dist_configs-DEV.sh && \
    bash build/assemble/build/$DIST_ARTIFACT/$DIST_VER/status.sh
```

The JOD Distribution TEMPLATE's build command is executed using a DEV's configs file that define mandatory configs for development purposes.
