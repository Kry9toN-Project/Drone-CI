# ENV for device
export PATH="/root/tools/clang13/bin:${PATH}"
export ARCH=arm64
export KBUILD_BUILD_USER=root
export KBUILD_BUILD_HOST=KryPtoN-Project
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb
ZIP_NAME="KryPtoN-vince-${CODENAME}-4.9-${DRONE_REPO_BRANCH}-${tanggal}.zip"
SF_PATH="4.9/$DRONE_REPO_BRANCH"

# path link web
CATEGORIE="vince/4.9"

# Compile plox
function compile() {
        make O=out ARCH=arm64 vince-krypton_defconfig
        make -j$(nproc --all) O=out \
                      ARCH=arm64 \
		      LOCALVERSION="-${CODENAME}-${tanggal}" \
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
        cp out/arch/arm64/boot/Image.gz-dtb /root/AnyKernel/zImage
        paste
}
