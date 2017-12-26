#!/bin/bash
#收集数据
read -p "请保持目录结构的完整，安装前请连接wifi，按回车键继续" var
#echo "请输入你的pkg路径，格式为绝对路径,如果没有本地pkg文件请直接回车"
#read pkg
#echo "请输入你的安装分区,小心！！这将格式化你所输入的分区，形如/dev/sdX"
#read fenqu


# copy `mirrorlist` to `/ect/pacman.d`
#cp ./pacman/mirrorlist /etc/pacman.d/mirrorlist
# copy `pacman.conf` to `/ect`
#cp ./pacman/pacman.conf /etc/pacman.conf
# refresh the new mirrors
sudo pacman -Syy 
#格式化分区为ext4
#mkfs.ext4 -F $fenqu
#挂载分区
#mount $fenqu /mnt
#复制需要的文件
#cp -r ./diy /mnt/diy
#复制安装包
#if [ ! -n "$pkg" ]
#then echo "无pkg"
#else
#mkdir -p /mnt/var/cache/pacman/pkg
#cp -r $pkg/* /mnt/var/cache/pacman/pkg/
#f#i
# install the basic packages for the new system
pacstrap  /mnt base base-devel

# generate an fstab file for the new system
genfstab -U /mnt >> /mnt/etc/fstab
#复制继续安装脚本
cp continue.sh /mnt/continue.sh
chmod 755 /mnt/continue.sh
# run 'continue_install.bash' via `arch-chroot`
arch-chroot /mnt  /continue.sh
rm /mnt/continue.sh
rm -rf /mnt/diy 

# umount the partition
umount -R /mnt
read -p "安装完毕，请指示！！！" var
