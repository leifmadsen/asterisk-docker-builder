# asterisk-docker-builder
Build Asterisk source into RPM packages as basis of a Docker container image.

> **NOTE**: This is a work in progress. More updates to follow as this stabilizes.

## Building the RPM builder image
There are two `Dockerfiles`; one for building the container image that will
result in RPMS, and one that will build the actual Asterisk container image.

To build the RPM builder:

```bash
docker build -t username/astbuilder:latest -f Dockerfile.asterisk-builder .
```

### Build RPMS
You can now use your new Docker container image to build yourself a fancy set
of Asterisk RPMs. This is done using `fedpkg` to build RPM dependencies (`speex`,
  `speexdsp`, `dahdi-tools`, `libpri`, `libresample`, `libss7`) and then builds Asterisk 13.

Then you run the following to build out the RPMs:

```
docker run -ti username/astbuilder
```

After a while (probably a good 10-15 minutes), you should have resulting RPMs that
have been built from the Fedora SPEC files.

> **NOTE**: At some point this will be enhanced somehow to allow resulting Asterisk
> RPMs to be

### Accessing RPMs when building Asterisk container image
> **NOTE**: Hopefully this process will change soon and be a little more automated.

We need to copy out our resulting RPMs so that we can install them into our new
Asterisk container image we're about to build. Copying the RPMs out of the container
can be done with the following `docker` commands.

#### Get the image name
```bash
docker ps -a

CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                      PORTS               NAMES
5baee40b62c2        madsen/astbuilder   "/bin/sh -c ./buildit"   34 minutes ago      Exited (0) 22 minutes ago                       hungry_torvalds
```

#### Copy the files out
```bash
docker cp hungry_torvalds:/buildrpms/localrpms/ ./rpms/
```

You should now have many RPMs sitting in your local `rpms/` directory.

## Building Asterisk container image
Last step is to build out your container image. The `Dockerfile` for our new image
will be installing the RPMs that you built within the builder image. These RPMs will
get added to the container image on build by mounting the files from the host into
the build via volume.

```bash
docker build -t username/asterisk:13.3.2-1 -f Dockerfile.asterisk .
```
