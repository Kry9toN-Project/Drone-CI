    # Upload
    function upload() {
        cd /root/AnyKernel
        spawn sshpass -p ${SF_PASS} kry9ton@frs.sourceforge.net:/home/frs/project/krypton-project > /dev/null 2>&1 <<EOF
mkdir $DEVICE
cd $DEVICE
mkdir -p $SF_PATH
cd $SF_PATH
put $ZIP_NAME
exit
EOF
        expect {
            "RSA key fingerprint" {
             send "yes\r"
            }
        }
        expect "#"
    }

    # Send info plox channel
    function sendRelese() {
            PATH="/root/tools/clang/bin:${PATH}"
            curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
                            -d chat_id=$chat_id_rilis \
                            -d "disable_web_page_preview=true" \
                            -d "parse_mode=html" \
                            -d text="<b>🔥KryPtoN Kernel</b> is <b>Release</b>%0A📱 Device: $DEVICE%0ALinux version: $LINUX_VERSION%0A🆑 Changelog : <code>$CHANGELOG</code>%0A<a href='https://kryptonproject.my.id/'>⬇️ Download</a>"
    }

upload
sendRelese
