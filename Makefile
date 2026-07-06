# SPDX-License-Identifier: GPL-3.0-or-later
# SPDX-FileCopyrightText: Copyright (C) 2026 River Games

KERNELCONFIG ?= menuconfig
ARCH = $(shell cat arch.txt)

all:
	make initial

system: sysroot/boot/LineKernel.gz

system-essentials: sysroot/opt/systemdata/LineKernel.gz sysroot/

sysroot/opt/systemdata/LineKernel.gz:
	# GENERATE THIS WITH: `make kernelconfig`
	make LineKernel/.config
	cd LineKernel; make ARCH=$(ARCH)
	cp LineKernel/LineKernel.gz sysroot/boot/LineKernel.gz

arch-%:
	echo $* > arch.txt

initial:
	mkdir -p sysroot sysroot/boot/

kernelconfig: kernel$(KERNELCONFIG)config
kernel%config:
	cd LineKernel; make $*config ARCH=$(ARCH)

clean:
	cd LineKernel; make distclean ARCH=$(ARCH)
	cd CLineB; make clean ARCH=$(ARCH)
	rm -r sysroot arch.txt

.PHONY: all system arch-% initial kernelconfig kernel%config clean
