    # Upload
    function upload() {
        cd /root/AnyKernel
        ssh-keyscan -H frs.sourceforge.net >> ~/.ssh/known_hosts
        sshpass -p $SF_PASS sftp -oBatchMode=no kry9ton@frs.sourceforge.net:/home/frs/project/krypton-project > /dev/null 2>&1 <<EOF
mkdir $DEVICE
cd $DEVICE
mkdir -p $SF_PATH
cd $SF_PATH
put $ZIP_NAME
exit
EOF
    }

    # Send info plox channel
    function sendRelese() {
            PATH="/root/tools/clang/bin:${PATH}"
            curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
                            -d chat_id=$chat_id \
                            -d "disable_web_page_preview=true" \
                            -d "parse_mode=html" \
                            -d text="<b>🔥KryPtoN Kernel</b> is <b>Release</b>%0A📱 Device: $DEVICE%0A🆑 Changelog : <code>$(echo $CHANGELOG | sed 's/<br>/%0A/g')</code>%0A<a href='https://kryptonproject.my.id/'>⬇️ Download</a>"
    }

function gitpush() {
        cd $ROOT_DIR
        git clone https://github.com/Kry9toN-Project/Kry9toN-Project.github.io webgit
        cp $mdname webgit/_miatoll/
        cd webgit
        git add -A
        git commit -m "[CI] New relese kernel"
        git push https://${github_cert}github.com/Kry9toN-Project/Kry9toN-Project.github.io
        cd $ROOT_DIR
}

upload
gitpush
sendRelese
