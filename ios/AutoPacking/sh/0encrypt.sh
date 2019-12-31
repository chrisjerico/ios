#!/bin/sh



# 从Xcode运行需要先cd到当前目录
if [ ! -n "$2" ] ;then
    echo "!"
else
    cd $2
fi

__String=$1

echo "$__String" | openssl rsautl -encrypt -pubin -inkey pub.pem | openssl enc -A -base64 > Ciphertext.txt
