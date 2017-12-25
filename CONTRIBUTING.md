All proposed improvements are welcome. Just make sure that you have tested your changes before you submit new pull request.

Full test procedure:

* Generate clean MLL source tree with ``make src``. This will produce compressed archive file which contains the MLL source tree.
* Copy or move the source archive file in empty folder and then extract the archive.
* Build MLL with ``./build_minimal_linux_live.sh``. You should be able to run MLL with the changes you have made (``./qemu-bios.sh`` and/or ``./qemu-uefi.sh``).
* Repackage the MLL ISO image with ``./repackage.sh``. You should be able to run MLL with the changes you have made (``./qemu-bios.sh`` and/or ``./qemu-uefi.sh``).
* Test the generated Docker functionality with ``./test_docker_image.sh``. You should see message that the test has passed.
* Run shell console in Docker with ``./run_docker_console.sh``. You should be able to invoke all MLL binaries and scripts from this console.
