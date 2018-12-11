# ghostscript-packager
Use for packaging Ghostscript binaries installed by apt-buildpack for use in applications

## Creating the Resource Library

The process of packaging the resources to include in the application has been automated with 2 applications. This one for packaging Ghostscript (due to special needs in the way the archive is created) and another that should work for most others.

The general packager can be found [here](https://github.com/bstarke/apt-cf-packager).

## Working With the APT Buildpack

The [APT Buildpack](https://github.com/cloudfoundry/apt-buildpack) is used to install needed binaries in the container of the application on PCF.  The buildpack should not be used for deploying applications directly, but is used by the packager applications as a means to determine which binaries are needed to be packaged up.

### Modify the `apt.yml`

- When using the Ghostscript packager you should not need to modify this file. The packager is intended to be used with one installed package. This is because the packager application will use the last line of the apt.yml to determine the directory name inside the zip file and the name of the zip file. In the case below the zip file will have all the binaries in a directory inside the zip named "ghostscript".

```yml
---
packages:
- ghostscript
```

### Modify the `manifest.yml` if needed

- When using the Ghostscript packager you will need to specify the stack you need the binaries packaged for. Use the same stack you will be deploying your applicaion on.

```yml
---
applications:
- name: ghost
  memory: 64M
  disk_quota: 512M
  path: public
  stack: cflinuxfs3 #Change the stack here
  command: $HOME/public/package.sh && rm $HOME/public/package.sh && $HOME/boot.sh
  buildpacks:
  - https://github.com/cloudfoundry/apt-buildpack.git
  - staticfile_buildpack
```

## Push to PCF

- Push the application to PCF using `cf push`.
- Open a browser to the route you deployed the application.
- Click the link to download the zip.

## Upload the archive to your repository (Artifactory, Nexus, Archiva, etc.)

- Use the appropriate group, artifact and version
- Add the OS version the artifact was created from in the version OR qualifier.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.ghostscript</groupId>
    <artifactId>ghostscript</artifactId>
    <version>9.76</version>
    <qualifier>bionic</qualifier>
    <packaging>zip</packaging>
</project>
```