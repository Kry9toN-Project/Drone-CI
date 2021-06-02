# ENV for device
ZIP_NAME="${CODENAME}-BLC-MIATOLL-MIUI-${tanggal}.zip"
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb
START=$(date +"%s")
export PATH="/root/tools/clang/bin:${PATH}"
export ARCH=arm64
export KBUILD_BUILD_USER=Zoel
export KBUILD_BUILD_HOST=Thanksyou
SF_PATH="MIUI"

# path link web
CATEGORIE="MIUI"

# Compile plox
function compile() {
        make O=out ARCH=arm64 cust_defconfig
        make -j$(nproc --all) O=out \
                      ARCH=arm64 \
		      LOCALVERSION="-${CODENAME}-${tanggal}" \
                      CC=clang \
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
