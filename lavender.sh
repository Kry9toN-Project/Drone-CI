# ENV for device
ZIP_NAME="aLn-Come_Back-4.19-BLC-lavender-${tanggal}.zip"
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb
START=$(date +"%s")
export PATH="/root/aosp/clang/bin:/root/aosp/gcc32/bin:/root/aosp/gcc/bin:${PATH}"
export ARCH=arm64
export KBUILD_BUILD_USER=alanndz
export KBUILD_BUILD_HOST=BiancaProject
SF_PATH="AOSP"

# path link web
CATEGORIE="AOSP"

# Compile plox
function compile() {
        make O=out ARCH=arm64 lavender_defconfig
        make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-gnu- \
		      CROSS_COMPILE_ARM32=arm-linux-gnueabi- 2>&1 | tee build.log
            if ! [ -a $IMAGE ]; then
                finerr
		stikerr
                exit 1
            fi
        cp $IMAGE /root/AnyKernel/
        paste
}
