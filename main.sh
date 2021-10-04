#!/usr/bin/env bash
ROOT_DIR=$(pwd)
START=$(date +"%s")
chat_id="-1001348632957"
tanggal=$(TZ=Asia/Jakarta date "+%Y%m%d-%H%M")

if [ $DEVICE = vince ]; then
    echo "Building for $DEVICE"
    source vince.sh
elif [ $DEVICE = lavender ]; then
    echo "Building for $DEVICE"
    source lavender.sh
elif [ $DEVICE = miatoll ]; then
    echo "Building for $DEVICE"
    source miatoll.sh
elif [ $DEVICE = miatoll_miui ]; then
    echo "Building for $DEVICE"
    source miui.sh
elif [ $DEVICE = miatoll_gcc ]; then
    echo "Building for $DEVICE"
    source miatollgcc.sh
else
    echo "Env DEVICE not setup on script CI"
    exit 1
fi

# sticker plox
function sticker() {
        curl -s -X POST "https://api.telegram.org/bot$token/sendSticker" \
                        -d sticker="CAACAgUAAxkBAAEB49tgLH6C7_cNIMnJEqR12lMOvTrYcgACHQIAArCPyVZFBJ4jXRiwjx4E" \
                        -d chat_id=$chat_id
}

# Stiker Error
function stikerr() {
	curl -s -F chat_id=$chat_id -F sticker="CAACAgIAAxkBAAEB49lgLH47y0sIlWuX_C-PxEQn9xslpAACAgADBc7CLYQoNSykq4gQHgQ" https://api.telegram.org/bot$token/sendSticker
}

# Send info plox channel
function sendinfo() {
        curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
                        -d chat_id=$chat_id \
                        -d "disable_web_page_preview=true" \
                        -d "parse_mode=html" \
                        -d text="<b>KryPtoN Kernel</b> new build is up%0AStarted on <code>DroneCI</code>%0AFor device <b>${DEVICE}</b>%0Abranch <code>$(git rev-parse --abbrev-ref HEAD)</code> %0AUnder commit <code>$(git log --pretty=format:'"%h : %s"' -1)</code>%0AUsing compiler: <code>$(clang --version | head -n 1 | perl -pe 's/\(https.*?\)//gs' | sed -e 's/  */ /g')</code>%0AStarted on <code>$(TZ=Asia/Jakarta date)</code>%0A<b>DroneCI Status</b> <a href='https://cloud.drone.io/Kry9toN'>here</a>"
}

# Push kernel to channel
function push() {
        cd /root/AnyKernel
	curl -F document=@$ZIP_NAME "https://api.telegram.org/bot$token/sendDocument" \
			-F chat_id=$chat_id \
			-F "disable_web_page_preview=true" \
			-F "parse_mode=html" \
			-F caption="Build took $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)."
        cd $ROOT_DIR
}

# Function upload logs to my own TELEGRAM paste
function paste() {
        curl -F document=@build.log "https://api.telegram.org/bot$token/sendDocument" \
			-F chat_id=$chat_id \
			-F "disable_web_page_preview=true" \
			-F "parse_mode=html"
}

# Fin Error
function finerr() {
        paste
        curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
			-d chat_id=$chat_id \
			-d "disable_web_page_preview=true" \
			-d "parse_mode=markdown" \
			-d text="Job DroneCI throw an error(s)"
}

# Zipping
function zipping() {
        cd /root/AnyKernel
        git checkout ${DEVICE}
	git pull
        zip -r9 $ZIP_NAME *
        cd $ROOT_DIR
}

sendinfo
compile
zipping
# include webmd
source web/generator.sh
END=$(date +"%s")
DIFF=$(($END - $START))
push
sleep 4
sticker
if [ $RELEASE = true ]; then
echo "Release build!"
source release.sh
fi
