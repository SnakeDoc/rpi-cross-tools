###
# Makefile for cross-tools
#
# Contructs a cross-compilation toolchain
#
# Usage: make <your-target>
#
###

all: clean crosstool-ng cross-tools

crosstool-ng:
	./run.sh crosstool-ng || true

crosstool-ng-archive:
	./run archive crosstool-ng

rpi: crosstool-ng
	./run.sh cross-tools rpi
	./run.sh archive rpi-cross-tools

rpi2: crosstool-ng
	./run.sh cross-tools rpi2
	./run.sh archive rpi2-cross-tools

clean:
	chmod -R +w target || true
	rm -rf target || true

clean-bin: clean-crosstool-ng clean-cross-tools

clean-crosstool-ng:
	rm -rf target/crosstool-ng || true

clean-cross-tools:
	chmod -R +w target/*cross-tools || true
	rm -rf target/*cross-tools || true
