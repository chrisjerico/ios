#!/bin/sh


__String=$1
__KeyFile=$2
__OutputFile=$3


# RSA公钥加密
#echo "$__String" | openssl rsautl -encrypt -pubin -inkey $__KeyFile | openssl enc -A -base64 > Ciphertext.txt

# RSA私钥签名
echo "$__String" | openssl rsautl -sign -inkey $__KeyFile | openssl enc -A -base64 > $__OutputFile
