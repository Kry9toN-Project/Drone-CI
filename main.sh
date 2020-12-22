#!/usr/bin/env bash
START=$(date +"%s")
chat_id="-1001348632957"
tanggal=$(TZ=Asia/Jakarta date "+%Y%m%d-%H%M")

if [ $DEVICE = vince ]; then
    echo "Building for $DEVICE"
    source vince.sh
elif [ $DEVICE = lavender ]; then
    echo "Building for $DEVICE"
    source lavender.sh
elif [ $DEVICE = joyeuse ]; then
    echo "Building for $DEVICE"
    source joyeuse.sh
else
    echo "Env DEVICE not setup on script CI"
    exit 1
fi

# sticker plox
function sticker() {
        curl -s -X POST "https://api.telegram.org/bot$token/sendSticker" \
                        -d sticker="CAADBQADBgADZMYlHVmIXcRlbUt_Ag" \
                        -d chat_id=$chat_id
}

# Stiker Error
function stikerr() {
	curl -s -F chat_id=$chat_id -F sticker="CAADBQADzwIAAnBaORAiq8ke6PAt0wI" https://api.telegram.org/bot$token/sendSticker
}

# Send info plox channel
function sendinfo() {
        PATH="/root/tools/clang/bin:${PATH}"
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
			-F chat_id="$chat_id" \
			-F "disable_web_page_preview=true" \
			-F "parse_mode=html" \
			-F caption="Build took $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)."
}

# Function upload logs to my own TELEGRAM paste
function paste() {
        cat build.log | curl -F document=@build.log "https://api.telegram.org/bot$token/sendDocument" \
			-F chat_id="$chat_id" \
			-F "disable_web_page_preview=true" \
			-F "parse_mode=html" 
}

# Fin Error
function finerr() {
        paste
        curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
			-d chat_id="$chat_id" \
			-d "disable_web_page_preview=true" \
			-d "parse_mode=markdown" \
			-d text="Job DroneCI throw an error(s)"
}

# Zipping
function zipping() {
        cd /root/AnyKernel
        git checkout ${DEVICE}
        zip -r9 $ZIP_NAME *
        cd ..
}


if [ $RELEASE = true ]; then
    # Send info plox channel
    function sendRelese() {
            PATH="/root/tools/clang/bin:${PATH}"
            curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
                            -d chat_id=$chat_id \
                            -d "disable_web_page_preview=true" \
                            -d "parse_mode=html" \
                            -d text="<b>🔥KryPtoN Kernel</b> is <b>Release</b>%0A📱 Device: $DEVICE%0ALinux version: $LINUX_VERSION%0A🆑 Changelog : <code>$CHANGELOG</code>%0A<a href='https://kryptonproject.my.id/'>⬇️ Download</a>"
    }

    #Upload
    function upload() {
        cd /root/AnyKernel
        sshpass -p ${SF_PASS} kry9ton@frs.sourceforge.net:/home/frs/project/krypton-project > /dev/null 2>&1 <<EOF
mkdir $DEVICE
cd $DEVICE
mkdir -p $SF_PATH
cd $SF_PATH
put $ZIP_NAME
exit
EOF
    }
fi

sendinfo
compile
zipping
# include webmd
source web/generator.sh
END=$(date +"%s")
DIFF=$(($END - $START))
paste
push
sticker
sendRelese
upload
