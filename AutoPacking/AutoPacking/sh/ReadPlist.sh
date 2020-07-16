#!/bin/sh

__OutputFile1=$1
__OutputFile2=$2
__OutputFile3=$3
__OutputFile4=$4

__PlistFile=$5

/usr/libexec/PlistBuddy -c "print" $__PlistFile > $__OutputFile1
