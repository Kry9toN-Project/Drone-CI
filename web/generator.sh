#!/usr/bin/env bash
mdname="${ZIP_NAME}.md"
tanggalfile=$(TZ=Asia/Jakarta date "+%Y/%m/%d")
filesize=$(du -h /root/AnyKernel/$ZIP_NAME | awk '{print $1;}')
mdsum=$(md5sum /root/AnyKernel/$ZIP_NAME | awk '{print $1;}')
LINK_SF=https://sourceforge.net/projects/krypton-project/files/${DEVICE}/${SF_PATH}/${ZIP_NAME}

# Membuat file .md
function md() {
     echo "---" >> ${mdname}
     echo "name: $ZIP_NAME" >> ${mdname}
     echo "date: $tanggalfile" >> ${mdname}
     echo "size: $filesize" >> ${mdname}
     echo "version: $CODENAME" >> ${mdname}
     echo "md5: $mdsum" >> ${mdname}
     echo "changelog: $CHANGELOG" >> ${mdname}
     echo "categories: $CATEGORIE" >> ${mdname}
     echo "layout: waitting" >> ${mdname}
     echo "link: $LINK_SF" >> ${mdname}
     echo "---" >> ${mdname}
}

# Kirim File .md
function sendmd() {
	curl -F document=@${mdname} "https://api.telegram.org/bot$token/sendDocument" \
			-F chat_id=$chat_id \
			-F "disable_web_page_preview=true" \
			-F "parse_mode=html"
}

md
sendmd
