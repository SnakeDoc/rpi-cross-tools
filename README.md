Raspberry Pi Cross Compilation Tools
============================

Automated scripts which build a cross-compilation toolchain targeting Raspberry Pi or Raspberry Pi 2

Uses Linaro versions of GCC, Binutils, and Glibc to provide performance and optimization improvements on the ARM architecture CPU family.

#### Raspberry Pi Target Specs:

 - Target: Raspberry Pi
 - Target Arch: ARMv6 (armv6zk)
 - Target CPU: ARM1176JZF-S
 - Target FPU: VFP
 - Target Endianness: LITTLE

#### Raspberry Pi 2 Target Specs:

 - Target: Raspberry Pi 2
 - Target Arch: ARMv7 (armv7)
 - Target CPU: Cortex-A7
 - Target FPU: Neon-VFPv4
 - Target Endianness: LITTLE

How To Build:
--------------------

Building is easy, you just issue the following command from the terminal:

```bash
make <target-name>
```

For example, if you desire to build the Raspberry Pi 2 cross-tools:

```bash
make rpi2
```

After the build completes, there will be an archive available in the `archives/` directory.

How To Install:
---------------------

Installing is easy. After you have downloaded the `tar.gz` archive, extract it with the following command:

```bash
tar -zxvf <archive-name>.tar.gz
```

For example, if you downloaded the latest Raspberry Pi 2 cross-tools:

```bash
tar -zxvf rpi2-cross-tools.tar.gz
```

Now cd into the directory:

```bash
cd <cross-tools-directory>
```

For example, if you extracted the latest Raspberry Pi 2 cross-tools:

```bash
cd rpi2-cross-tools
```

Now, use the `install.sh` script to install to a directory of your desire:

```bash
./install.sh <install-directory>
```

For example, if you wish to install to the `/opt` directory:

```bash
./install.sh /opt
```

