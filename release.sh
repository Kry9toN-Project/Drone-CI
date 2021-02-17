    # Upload
    function upload() {
        cd /root/AnyKernel
        ssh-keyscan -H frs.sourceforge.net >> ~/.ssh/known_hosts
        sshpass -p "$SF_PASS" sftp -oBatchMode=no kry9ton@frs.sourceforge.net:/home/frs/project/krypton-project 2>&1 <<EOF
mkdir $DEVICE
cd $DEVICE
mkdir $SF_PATH
cd $SF_PATH
put $ZIP_NAME
exit
EOF
    }

    # Send info plox channel
    function sendRelese() {
            pwd
            cd $ROOT_DIR/img
            ls
            curl -F photo=@icon.jpg "https://api.telegram.org/bot$token/sendPhoto" \
                            -F chat_id=$chat_id \
                            -F "disable_web_page_preview=true" \
                            -F "parse_mode=html" \
                            -F caption="[CI/BOT]🔥<b>KryPtoN Kernel</b> is <b>Release</b>
📱 Device: $DEVICE
🔢 Version: $WEB_VERSIONS
🆑 Changelog : <code>$(echo $CHANGELOG | sed 's/<br>/\n/g')</code>

💸 Donate Me if you like my work%0A<a href='https://www.paypal.me/KomodoOS'>Paypal</a> | <a href='https://saweria.co/donate/Kry9toN'>Saweria</a> for Indonesian
<a href='http://t.me/KKgrupofficial'>👥 Group</a> | <a href='http://t.me/KryPtoNKernel'>📺 Channel</a>

<a href='https://kryptonproject.my.id/'>⬇️ Download</a>"
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

#upload
#gitpush
sendRelese
