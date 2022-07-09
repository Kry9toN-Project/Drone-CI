# ENV for device
ZIP_NAME="${CODENAME}-BLC-MIATOLL-AOSP-${tanggal}.zip"
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz
IMAGE2=$(pwd)/out/arch/arm64/boot/dtbo.img
START=$(date +"%s")
GCC="/root/tools/gcc/bin/aarch64-elf-"
GCC32="/root/tools/gccarm/bin/arm-eabi-"
export GCC
export GCC32
export ARCH=arm64
export KBUILD_BUILD_USER=dindascape
export KBUILD_BUILD_HOST=notabook
SF_PATH="AOSP"

# path link web
CATEGORIE="AOSP"

# Compile plox
function compile() {
        make O=out  cust_defconfig
        make -s -C $(pwd) CROSS_COMPILE=${GCC} CROSS_COMPILE_ARM32=${GCC32} O=out -j32 2>&1 | tee build.log
            if ! [ -a $IMAGE ]; then
                finerr
		stikerr
                exit 1
            fi
        cp $IMAGE /root/AnyKernel/
        cp $IMAGE2 /root/AnyKernel/
        paste
}
