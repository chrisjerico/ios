#!/bin/sh

__OutputFile1=$1
__OutputFile2=$2
__OutputFile3=$3
__OutputFile4=$4

__String=$5
__KeyFile=$6

# RSA公钥加密
#echo "$__String" | openssl rsautl -encrypt -pubin -inkey $__KeyFile | openssl enc -A -base64 > Ciphertext.txt

# RSA私钥签名
echo "$__String" | openssl rsautl -sign -inkey $__KeyFile | openssl enc -A -base64 > $__OutputFile1
