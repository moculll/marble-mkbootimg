#!/bin/env bash

HEADER_VERSION=4
PYTHON_RUN="python3"
OS_VERSION="12.0.0.1"
PATCH_LEVEL="2024-03"

OUTPUT_FOLDER="${PWD}/output"
BOOT_SOURCES_FOLDER="${PWD}/boot_sources"
INPUT_IMG=
OUTPUT_IMG="${OUTPUT_FOLDER}/boot.img"
KERNEL_INPUT="${BOOT_SOURCES_FOLDER}/kernel"
RAMDISK_INPUT="${BOOT_SOURCES_FOLDER}/ramdisk"
MKBOOTIMG_PY="${PWD}/system_tools_mkbootimg/mkbootimg.py"
UNPACKIMG_PY="${PWD}/system_tools_mkbootimg/unpack_bootimg.py"
GENERATE_KEY="${PWD}/system_tools_mkbootimg/tests/data/testkey_rsa2048.pem"

SCRIPT_FOR_RUN=${MKBOOTIMG_PY}

function print_help {
    echo "Usage: $0 [-h] [-u unpack_img_path] [-r ramdisk_path] [-k kernel_path] [-s]"
    echo "example for making a deault img: $0"
    echo "example for unpacking boot.img: $0 -u ./boot.img"
    echo "example for making an img while replacing the ramdisk: $0 -r boot_sources/ramdisk_2"
    echo "example for using a custom kernel: $0 -k ./boot_sources/kernel_2"
    echo "example for using a custom signature_key: $0 -s ./key_rsa2048.pem"
    echo "example for using custon signature_key and ramdisk: $0 -s ./key_rsa2048.pem -r ramdisk_3"
    echo "Options:"
    echo "  -h, [help]     Show this help message and exit"
    echo "  -u, [unpack]   unpack a boot img in ./boot_sources"
    echo "  -r, [ramdisk]  Replace the ramdisk, this defaults to be boot_sources/ramdisk"
    echo "  -k, [kernel]  Replace the kernel, this defaults to be boot_sources/kernel"
    echo "  -s, [signature_key] gki signature key path, this defaults to be system_tools_mkbootimg/tests/data/testkey_rsa2048.pem"
    echo "Note: put kernel and ramdisk(this already have a template) in boot_sources, run $0, check your boot img file in output"
    echo "Note: if you don't know what ramdisk you can use OR you wanna keep your magisk, then you should use KernelFlasher to get your boot img \
and then use -u [your_boot_img_path] to unpack ramdisk/kernel in boot_source"
}
if [ ! -e "${PWD}/system_tools_mkbootimg" ]; then
	echo "you have to run script in system_tools_mkbootimg/../ folder"
	exit 1
fi
while getopts ":hu:o:" opt; do
    case ${opt} in
        h | help )
            print_help
            exit 0
            ;;
        o | output )
            if [[ ${OPTARG} == -* ]]; then
                echo "-o follows invalid path, Use Default output/boot.img"
                break
            fi
            OUTPUT_IMG="${OUTPUT_FOLDER}/${OPTARG}"
            ;;
        u | unpack )
            SCRIPT_FOR_RUN=${UNPACKIMG_PY}
            INPUT_IMG="${PWD}/${OPTARG}"
            if [ $# -gt $((OPTIND -1)) ]; then
                echo "Error: -u option cannot be combined with other options or arguments." >&2
                exit 1
            fi
            ;;
        r | ramdisk )
            RAMDISK_INPUT="${PWD}/${OPTARG}"
            ;;
        \? )
            echo "Invalid option: -$OPTARG, use -h, --help to print help message" >&2
            exit 1
            ;;
        : )
            echo "Option -$OPTARG requires an argument" >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))
if [ "${SCRIPT_FOR_RUN}" != "${MKBOOTIMG_PY}" ]; then
    "${PYTHON_RUN}" "${SCRIPT_FOR_RUN}" --boot_img ${INPUT_IMG} --out ${BOOT_SOURCES_FOLDER}
    echo "generated ramdisk kernel boot_signature in ./boot_sources"
else
    "${PYTHON_RUN}" "${SCRIPT_FOR_RUN}" --gki_signing_key "${GENERATE_KEY}" --header_version "${HEADER_VERSION}" -o "${OUTPUT_IMG}" --ramdisk "${RAMDISK_INPUT}" --kernel "${KERNEL_INPUT}" --os_version "${OS_VERSION}" --os_patch_level "${PATCH_LEVEL}"
    echo "generate ./output/boot.img done"
fi

exit 0
