# This is very simple Makefile which encapsulates the build
# process of "Minimal Linux Live". Type the following command
# for additional information:
#
# make help

.DEFAULT_GOAL := help

all: clean
	@time sh build_minimal_linux_live.sh

clean:
	@rm -rf source
	@rm -rf work
	@rm -f minimal_linux_live.iso

emulator:
	@if [ ! -f ./minimal_linux_live.iso ]; then echo "ISO image \"minimal_linux_live.iso\" not found."; exit 1; fi
	@if [ "$(shell uname -m)" = "x86_64" ]; then sh qemu64.sh; else sh qemu32.sh; fi

help:
	@echo ""
	@echo "    make all          clean the workspace and then generate \"minimal_linux_live.iso\""
	@echo ""
	@echo "    make clean        remove all generated files"
	@echo ""
	@echo "    make emulator     run \"Minimal Linux Live\" in qemu"
	@echo ""
	@echo "    make help         this is the default target"
	@echo ""

