## Minimal Linux Mincs (experimental work)

The purpose of this branch is to add the [MINCS](https://github.com/mhiramat/mincs) container support in Minimal Linux Live. Most of the work will be based on the [Boot2MINC](https://github.com/mhiramat/boot2minc) project.

The long term goal is to run [Docker](https://www.docker.com/) directly in Minimal Linux Live. However, there are several issues:

- [solved] Currently MLL provides kernel without cgroups/namespaces support.
- [solved] Assuming the first condition has been fulfilled, currently the initializing process doesn't mount the cgroups hierarchy at all. Moreover, Docker has special requirements in this particular area.
- [solved] The MLL environment doesn't provide the binary utilities required by Docker.
- The MLL environment doesn't provide the library dependencies required by the binary utilities mentioned in the previous bullet point. Some kernel modules requred by docker are missing in MLL.

One way to solve all these issues and make Docker work in MLL is the following:

- [solved] Add proper support for MINCS (that's what the current branch is about).
- Find Docker image which in turn contains Docker and is able to run it properly (Docker in Docker).
- Use the MINCS utilities to convert the above mentioned docker image to MINCS image.
- Use MINCS as wrapper container for the converted Docker image.

MINCS works fine in the current branch state.

TODO:

- Clean this branch and leave only hte MINCS related stuff. In this way the build process will work fine on other machines. Right now the build process depends highly on the Ubuntu/Mint host system layout. 
- Create new branch based on this one where the Docker relates development will continue. 

May the force be with you! Live long and prosper! Hodor!
