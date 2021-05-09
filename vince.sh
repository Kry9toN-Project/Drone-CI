# ENV for device
export PATH="/root/tools/clang13/bin:${PATH}"
export LD_LIBRARY_PATH="/root/tools/clang13/bin/../lib:$PATH"
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
        make O=out ARCH=arm64 vince-perf_defconfig
        make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
		      LOCALVERSION="-KryPtoN🔥-${CODENAME}-${tanggal}" \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
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
