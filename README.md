# This is a script for generating android12-5.10-gki kernel
## this script tool requires linux envirenment
## Usage
```
git clone https://github.com/moculll/marble-mkbootimg.git
cd marble-mkbootimg
./mkbootimg.sh -h
```
- after you type in the code above, you can see output guide like this:
```
Usage: ./mkbootimg.sh [-h] [-u unpack_img_path] [-r ramdisk_path] [-k kernel_path] [-s]
example for making a deault img: ./mkbootimg.sh
example for unpacking boot.img: ./mkbootimg.sh -u ./boot.img
example for making an img while replacing the ramdisk: ./mkbootimg.sh -r boot_sources/ramdisk_2
example for using a custom kernel: ./mkbootimg.sh -k ./boot_sources/kernel_2
example for using a custom signature_key: ./mkbootimg.sh -s ./key_rsa2048.pem
example for changing the output file name: ./mkbootimg.sh -o boot_2.img
example for using custon signature_key and ramdisk: ./mkbootimg.sh -s ./key_rsa2048.pem -r ramdisk_3
Options:
  -h, [help]     Show this help message and exit
  -u, [unpack]   unpack a boot img in ./boot_sources
  -r, [ramdisk]  Replace the ramdisk, this defaults to be boot_sources/ramdisk
  -k, [kernel]  Replace the kernel, this defaults to be boot_sources/kernel
  -o, [output_file_name] change the output file name
  -s, [signature_key] gki signature key path, this defaults to be system_tools_mkbootimg/tests/data/testkey_rsa2048.pem
Note: put kernel and ramdisk(this already have a template) in boot_sources, run ./mkbootimg.sh, check your boot img file in output
Note: if you don't know what ramdisk you can use OR you wanna keep your magisk, then you should use KernelFlasher to get your boot img and then use -u [your_boot_img_path] to unpack ramdisk/kernel in boot_source
```
## Example
#### if you have a boot.img for updating kernel, you need to unpack it first
```
./mkbootimg.sh -u ./boot.img
```
- after this, the unpack files including ramdisk/kernel/signature will be put in ./boot_sources folder

#### the next step is to use -k to generate a new img file
```
./mkbootimg.sh -k ./Image
```
- after this step, your new boot.img will be generated as output/boot.img

## Enjoy your flashing!
