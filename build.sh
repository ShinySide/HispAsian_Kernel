#!/bin/bash

local_dir=$PWD
ARCH='ARCH=arm' 
DEFCONFIG='VARIANT_DEFCONFIG=jf_tmo_defconfig jf_defconfig SELINUX_DEFCONFIG=selinux_defconfig'
jobs='-j12'

echo '*-*-*-*-*-*-*-*'
echo 'Making mrproper'
echo '*-*-*-*-*-*-*-*'
#make mrproper                                                               
rm -rf out
rm -rf ./mkbootimg_tools/boot.img
rm -rf ./mkbootimg_tools/boot/zImage
echo ''
echo ''                                                              
echo '*-*-*-*-*-*-*-*-'
echo 'Making defconfig'
echo '*-*-*-*-*-*-*-*-'
export $ARCH
make $DEFCONFIG
echo ''
echo ''
echo '*-*-*-*-*-*-*'
echo 'Making zImage'
echo '*-*-*-*-*-*-*'
time make $jobs
echo ''
echo ''
echo '*-*-*-*-*-*-*-*-*-*-*-*-*-*-'
echo 'Packing zImage into Boot.img'
echo '*-*-*-*-*-*-*-*-*-*-*-*-*-*-'
cp arch/arm/boot/zImage mkbootimg_tools/boot/zImage  
cd ./mkbootimg_tools
./mkboot boot boot.img
cd ../
echo ''
echo ''
echo '*-*-*-*-*-*-*-*-*-*-*-'
echo 'Copying files to ./out'
echo '*-*-*-*-*-*-*-*-*-*-*-'
mkdir -p out/system/lib/modules                                                                                               
find -name '*.ko' | xargs -I {} cp {} ./out/system/lib/modules/
cp mkbootimg_tools/boot.img out/
cp -r /META-INF out/
echo ''
echo ''
echo '*-*-*-*-*-*-*-*-*-*-*-*-*-*'
echo 'Zipping up completed kernel'
echo '*-*-*-*-*-*-*-*-*-*-*-*-*-*'
cd ./out
zip -r Kernel.zip ./system ./boot.img ./META-INF
echo ''
echo ''
echo '*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*'
echo 'Pushing Kernel.zip to ExtSdCard via ADB'
echo '*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*'
gnome-terminal -e 'adb push ./Kernel.zip /storage/extSdCard/'
echo ''
echo ''
echo '*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*'
echo 'Done,pushed to sdcard, and ready to flash'
echo '*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*'
