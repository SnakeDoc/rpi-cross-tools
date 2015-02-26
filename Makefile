###
# Makefile for Raspberry Pi 2 Compiler
# ARCH: ARMv7
# CPU:  Cortex-A7
# FPU:  Neon-VFPv4 
# Bits: 32
###

all: clean crosstool-ng cross-tools kernel firmware

crosstool-ng:
	./run.sh crosstool-ng


cross-tools:
	./run.sh cross-tools

kernel:

firmware:

clean:
	chmod -R +w target && rm -rf target


clean-crosstool-ng:
	rm -rf target/crosstool-ng


clean-cross-tools:
	chmod -R +w target/cross-tools && rm -rf target/cross-tools

clean-kernel:
	rm -rf target/kernel

clean-firmware:
	rm -rf target/firmware
