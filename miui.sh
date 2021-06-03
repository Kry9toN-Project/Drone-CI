# ENV for device
ZIP_NAME="${CODENAME}-BLC-MIATOLL-MIUI-${tanggal}.zip"
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb
START=$(date +"%s")
GCC="/root/tools/gcc-eva-arm64/bin/aarch64-elf-"
GCC32="/root/tools/gcc-eva-arm/bin/arm-eabi-"
export GCC
export GCC32
export ARCH=arm64
export KBUILD_BUILD_USER=Zoel
export KBUILD_BUILD_HOST=Thanksyou
SF_PATH="MIUI"

# path link web
CATEGORIE="MIUI"

# Compile plox
function compile() {
        make O=out ARCH=arm64 cust_defconfig
	make -s -C $(pwd) CROSS_COMPILE=${GCC} CROSS_COMPILE_ARM32=${GCC32} O=out -j32 2>&1 | tee build.log
            if ! [ -a $IMAGE ]; then
                finerr
		stikerr
                exit 1
            fi
        cp $IMAGE /root/AnyKernel/
        paste
}
