# ENV for device
ZIP_NAME="ProjectThanksYou-BLC-MIATOLL-AOSP-${tanggal}.zip"
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb
START=$(date +"%s")
export PATH="/root/tools/proton/bin:${PATH}"
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
                      CC=clang \
		      LD=ld.lld \
		      AR=llvm-ar \
		      NM=llvm-nm \
		      OBJDUMP=llvm-objdump \
		      STRIP=llvm-strip \
		      OBJCOPY=llvm-objcopy \
		      OBJSIZE=llvm-size \
		      READELF=llvm-readelf \
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
