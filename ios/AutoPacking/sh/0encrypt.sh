#!/bin/sh


__String=$1
__KeyFile=$2


# 从Xcode运行需要先cd到当前目录
if [ ! -n "$3" ] ;then
    echo "!"
else
    cd $3
fi

# RSA公钥加密
#echo "$__String" | openssl rsautl -encrypt -pubin -inkey $__KeyFile | openssl enc -A -base64 > Ciphertext.txt

# RSA私钥签名
echo "$__String" | openssl rsautl -sign -inkey $__KeyFile | openssl enc -A -base64 > Ciphertext.txt
