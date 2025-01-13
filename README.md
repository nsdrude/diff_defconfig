# Introduction

This repository contains scripts designed to work with defconfig files in a Git repository. These scripts allow users to generate and compare defconfig differences between branches in a systematic and efficient manner.

## diff_defconfig.py

### Description

Simple utility to diff two defconfig files

- Removes lines that are common to both defconfig files
- Prints a sorted list of unique lines

**Usage:**
```
./diff_defconfig.py <file1> <file1>
```

### Example

```
$ diff_defconfig.py configs/imx8mq_evk_defconfig configs/imx8mq_var_dart_defconfig
-> # CONFIG_SPI_FLASH_BAR is not set
<- CONFIG_ARCH_MISC_INIT=y
<- CONFIG_BOOTCOMMAND="run distro_bootcmd;run bsp_bootcmd"
-> CONFIG_BOOTCOMMAND="run bsp_bootcmd"
-> CONFIG_BOOTDELAY=1
-> CONFIG_BOOTP_PREFER_SERVERIP=y
<- CONFIG_DEFAULT_DEVICE_TREE="imx8mq-evk"
-> CONFIG_DEFAULT_DEVICE_TREE="imx8mq-var-dart-dt8mcustomboard"
-> CONFIG_DEFAULT_FDT_FILE="imx8mq-var-dart-dt8mcustomboard.dtb"
<- CONFIG_DM_MMC=y
<- CONFIG_DM_USB=y
<- CONFIG_EFI_ESRT=y
<- CONFIG_EFI_HAVE_CAPSULE_UPDATE=y
-> CONFIG_GPIO_HOG=y
-> CONFIG_NR_DRAM_BANKS=3
-> CONFIG_PHY_ADIN=y
<- CONFIG_SF_DEFAULT_MODE=0
<- CONFIG_SPLASH_SCREEN=y
<- CONFIG_SYS_I2C_MXC=y
<- CONFIG_SYS_LOAD_ADDR=0x40400000
-> CONFIG_SYS_LOAD_ADDR=0x40480000
<- CONFIG_SYS_MALLOC_F_LEN=0x2000
<- CONFIG_TARGET_IMX8MQ_EVK=y
-> CONFIG_TARGET_IMX8MQ_VAR_DART=y
<- CONFIG_USB_GADGET_MANUFACTURER="FSL"
-> CONFIG_USB_GADGET_MANUFACTURER="Variscite"
<- CONFIG_USB_TCPC=y
<- CONFIG_VIDEO_LOGO=y
```

## diff_defconfig_on_branch

`diff_defconfig_on_branch.sh` leverages diff_defconfig.py to compare two defconfigs on a specific branch.

It is helpful to know the changes in `<branch a>` when porting `<branch b>`, so the same changes can be made to `<branch b>`.

** Usage:**
```
# General
$ ./diff_defconfig_on_branch.sh \
    <repository> \
    <branch> \
    <defconfig a> \
    <defconfig b>

# Specific Example
$ ./diff_defconfig_on_branch.sh \
    ~/git/linux-imx/ \
    varigit/lf-6.6.y_6.6.23-2.0.0_var01 \
    imx_v8_defconfig \
    imx8_var_defconfig
```

## diff_defconfig_between_branches

`diff_defconfig_on_branch.sh` leverages diff_defconfig_on_branch.sh further by comparing the output of diff_defconfig_on_branch.sh on two branches.

This diff should be empty when porting from `<branch a>` to `<branch b>` and don't want to make any functional changes.

** Usage:**
```
# General
$ ./diff_defconfig_on_branch.sh \
    <repository> \
    <branch a> \
    <branch b> \
    <defconfig a> \
    <defconfig b>

# Specific Example
$ ./diff_defconfig_between_branches.sh \
    ~/git/linux-imx/ \
    varigit/lf-6.6.y_6.6.23-2.0.0_var01 \
    varigit/lf-6.6.y_6.6.52-2.2.0_var01 \
    imx_v8_defconfig \
    imx8_var_defconfig
```