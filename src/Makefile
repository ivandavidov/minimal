# This is very simple Makefile which encapsulates the build
# process of "Minimal Linux Live". Type the following command
# for additional information:
#
# make help

.DEFAULT_GOAL := help

all: clean
	@echo "Launching the main build script..."
	@time sh build_minimal_linux_live.sh 2>&1 | tee minimal_linux_live.log

clean:
	@echo "Removing source files..."
	@rm -rf source
	@echo "Removing generated work artifacts..."
	@rm -rf work
	@echo "Removing generated ISO image..."
	@rm -f minimal_linux_live.iso
	@echo "Removing predefined configuration files..."
	@rm -rf minimal_overlay/*.config
	@echo "Removing source level overlay software..."
	@cd minimal_overlay && rm -rf $(shell ls -d */) && cd ..
	@echo "Removing build log file..."
	@rm -f minimal_linux_live.log

qemu:
	@if [ ! -f ./minimal_linux_live.iso ]; then echo "ISO image \"minimal_linux_live.iso\" not found."; exit 1; fi
	@echo "Launching QEMU..."
	@if [ "$(shell uname -m)" = "x86_64" ]; then sh qemu64.sh; else sh qemu32.sh; fi

src:
	@echo "Generating source archive..."
	@rm -f minimal_linux_live_*_src.tar.xz
	@mkdir -p work
	@sh 08_prepare_src.sh 1>/dev/null
	@$(eval DATE_PARSED := $(shell LANG=en_US ; date +"%d-%b-%Y"))
	@cd work/src && tar -cpf - `ls -A` | xz - > ../../minimal_linux_live_$(DATE_PARSED)_src.tar.xz && cd ../..
	@echo "Source archive: minimal_linux_live_$(DATE_PARSED)_src.tar.xz"

help:
	@echo ""
	@echo "    make all          clean the workspace and then generate \"minimal_linux_live.iso\""
	@echo ""
	@echo "    make clean        remove all generated files"
	@echo ""
	@echo "    make src          generate 'tar.xz' source archive"
	@echo ""
	@echo "    make qemu         run \"Minimal Linux Live\" in qemu"
	@echo ""
	@echo "    make help         this is the default target"
	@echo ""

