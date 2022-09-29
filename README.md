# Description

Simple utility to diff two defconfig files

- Removes lines that are common to both defconfig files
- Prints a sorted list of unique lines

**Usage:**
```
./diff_defconfig.py <file1> <file1>
```

# Example

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
