## Minimal Linux Mincs (experimental work)

You can find the main website here:

The purpose of this branch is to add the [MINCS](https://github.com/mhiramat/mincs) container support to Minimal Linux Live. Proof of concept (PoC) project is [Boot2MINC](https://github.com/mhiramat/boot2minc).

In the long term the goal is to run [Docker](https://www.docker.com/) directly in Minimal Linux Live. However, there are several issues:

- Currently MLL provides kernel without cgroups/namespaces support.
- Assuming the first condition has been fulfilled, currently the initializing process doesn't mount the cgroups hierarchy at all. Moreover, Docker has special requirements in this particular area.
- The MLL userland (based on BusyBox) doesn't provide the binary utilities required by Docker.

One way to solve all these issues is the following:

- Add proper support for MINCS (that's what the current branch is about).
- Find Docker image which in turn contains Docker as is able to run it properly.
- Use the MINCS utilities to convert the above mentioned docker image to MINCS image.
- Use MINCS as wrapper container for the converted Docker image.
