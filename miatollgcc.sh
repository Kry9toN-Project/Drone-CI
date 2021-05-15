# ENV for device
ZIP_NAME="${CODENAME}-BLC-MIATOLL-AOSP-${tanggal}.zip"
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb
START=$(date +"%s")
CROSS_COMPILE="/root/tools/11/bin/aarch64-elf"
CROSS_COMPILE_ARM32="root/tools/arm11/bin/arm-eabi"
export CROSS_COMPILE
export CROSS_COMPILE_ARM32
export ARCH=arm64
export KBUILD_BUILD_USER=Zoel
export KBUILD_BUILD_HOST=Thanksyou
SF_PATH="AOSP"

# path link web
CATEGORIE="AOSP"

# Compile plox
function compile() {
        make O=out ARCH=arm64 cust_defconfig
        make -j$(nproc --all) O=out \
                      ARCH=arm64 \
		      LOCALVERSION="-${CODENAME}-${tanggal}" \
                      CROSS_COMPILE=aarch64-elf- \
		      CROSS_COMPILE_ARM32=arm-eabi- 2>&1 | tee build.log
            if ! [ -a $IMAGE ]; then
                finerr
		stikerr
                exit 1
            fi
        cp $IMAGE /root/AnyKernel/
        paste
}
