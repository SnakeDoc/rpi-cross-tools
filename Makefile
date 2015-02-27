###
# Makefile for Raspberry Pi 2 Compiler
# ARCH: ARMv7
# CPU:  Cortex-A7
# FPU:  Neon-VFPv4 
# Bits: 32
###

all: clean crosstool-ng cross-tools

crosstool-ng:
	./run.sh crosstool-ng

crosstool-ng-archive:
	./run archive crosstool-ng

cross-tools:
	./run.sh cross-tools

cross-tools-archive:
	./run.sh archive cross-tools

release: clean-crosstool-ng clean-cross-tools crosstool-ng cross-tools cross-tools-archive

clean:
	chmod -R +w target || true
	rm -rf target || true

clean-bin: clean-crosstool-ng clean-cross-tools

clean-crosstool-ng:
	rm -rf target/crosstool-ng || true

clean-cross-tools:
	chmod -R +w target/cross-tools || true
	rm -rf target/cross-tools || true
