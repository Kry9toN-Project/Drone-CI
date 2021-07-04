#!/usr/bin/env bash
ROOT_DIR=$(pwd)
START=$(date +"%s")
chat_id="-1001348632957"
tanggal=$(TZ=Asia/Jakarta date "+%Y%m%d-%H%M")
tanggalfile=$(TZ=Asia/Jakarta date "+%Y/%m/%d")

if [ $DEVICE = vince ]; then
    echo "Building for $DEVICE"
    source vince.sh
elif [ $DEVICE = lavender ]; then
    echo "Building for $DEVICE"
    source lavender.sh
elif [ $DEVICE = miatoll ]; then
    echo "Building for $DEVICE"
    source miatoll.sh
elif [ $DEVICE = miatoll_gcc ]; then
    echo "Building for $DEVICE"
    source miatollgcc.sh
elif [ $DEVICE = miatoll_miui ]; then
    echo "Building for $DEVICE"
    source miui.sh
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
                        -d text="<b>KryPtoN Kernel</b> new build nightly is up%0AStarted on <code>Circle CI</code>%0AFor device <b>${DEVICE}</b>%0Abranch <code>$(git rev-parse --abbrev-ref HEAD)</code> %0AUnder commit <code>$(git log --pretty=format:'"%h : %s"' -1)</code>%0AUsing compiler: <code>$(clang --version | head -n 1 | perl -pe 's/\(https.*?\)//gs' | sed -e 's/  */ /g')</code>%0AStarted on <code>$(TZ=Asia/Jakarta date)</code>%0A<b>DroneCI Status</b> <a href='https://cloud.drone.io/Kry9toN'>here</a>"
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
        zip -r9 $ZIP_NAME *
        cd $ROOT_DIR
}

# Membuat file .md
function md() {
     mdname="${ZIP_NAME}-Nightly.md"
     filesize=$(du -h /root/AnyKernel/$ZIP_NAME | awk '{print $1;}')
     mdsum=$(md5sum /root/AnyKernel/$ZIP_NAME | awk '{print $1;}')
     LINK_SF=https://sourceforge.net/projects/krypton-project/files/nightly/${ZIP_NAME}
     echo "---" >> ${mdname}
     echo "name: $ZIP_NAME" >> ${mdname}
     echo "date: $tanggalfile" >> ${mdname}
     echo "size: $filesize" >> ${mdname}
     echo "version: $CODENAME" >> ${mdname}
     echo "md5: $mdsum" >> ${mdname}
     echo "categories: nightly" >> ${mdname}
     echo "layout: waitting" >> ${mdname}
     echo "link: $LINK_SF" >> ${mdname}
     echo "---" >> ${mdname}
}

# Upload
function upload() {
    cd /root/AnyKernel
    ssh-keyscan -H frs.sourceforge.net >> ~/.ssh/known_hosts
    sshpass -p "$SF_PASS" sftp -oBatchMode=no kry9ton@frs.sourceforge.net:/home/frs/project/krypton-project 2>&1 <<EOF
mkdir nightly
cd nightly
put $ZIP_NAME
exit
EOF
}

function gitpush() {
    cd $ROOT_DIR
    git clone https://github.com/Kry9toN-Project/Kry9toN-Project.github.io webgit
    mkdir webgit/_nightly/
    cp $mdname webgit/_nightly/
    cd webgit
    git add -A
    git commit -m "[CI] New niglty build kernel"
    git push https://${github_cert}github.com/Kry9toN-Project/Kry9toN-Project.github.io
    cd $ROOT_DIR
}

sendinfo
compile
zipping
END=$(date +"%s")
DIFF=$(($END - $START))
push
sleep 4
sticker
md
upload
gitpush
