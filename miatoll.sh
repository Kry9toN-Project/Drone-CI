# ENV for device
ZIP_NAME="${CODENAME}-A12-BLC-MIATOLL-AOSP-${tanggal}.zip"
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb
DTBO=$(pwd)/out/arch/arm64/boot/dtbo.img
START=$(date +"%s")
export PATH="/root/tools/proton/bin:${PATH}"
export ARCH=arm64
export KBUILD_BUILD_USER=KryPtoN
export KBUILD_BUILD_HOST=Project
SF_PATH="AOSP"

# path link web
CATEGORIE="AOSP"

# Compile plox
function compile() {
        make O=out ARCH=arm64 miatoll_defconfig
        make -kj$(nproc --all) O=out \
                      ARCH=arm64 \
		      LOCALVERSION="-${CODENAME}-${tanggal}" \
                      CC=clang \
                      LD=ld.lld \
                      CROSS_COMPILE=aarch64-linux-gnu- \
		      CROSS_COMPILE_ARM32=arm-linux-gnueabi- 2>&1 | tee build.log
            if ! [ -a $IMAGE ]; then
                finerr
		stikerr
                exit 1
            fi
        cp $IMAGE /root/AnyKernel/
        cp $DTBO /root/AnyKernel/
        paste
}
