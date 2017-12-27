#!/bin/bash

echo '请输入你的esp分区，小心！！形如/dev/sdX'
read esp

# set the locale (system language)
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen
echo 'zh_TW.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen

# set the timezone0
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#同步时间
hwclock --systohc --utc
#设置主机名
echo Archlinux-ikoula > /etc/hostname

#设置并锁定dns
#echo "# servers
#nameserver 119.29.29.29
#nameserver 200.200.200.200" > /etc/resolv.conf
#chattr +i /etc/resolv.conf

#开启multilib
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist">> /etc/pacman.conf
pacman -Syu

#添加archlinuxcn源
echo  >> /etc/pacman.conf
echo "[archlinuxcn]" >> /etc/pacman.conf
echo "Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf
pacman -Syu --noconfirm archlinuxcn-keyring

#安装桌面环境
#pacman -S --noconfirm deepin  gnome 
#sed -i '108s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-deepin-greeter/' /etc/lightdm/lightdm.conf
#安装常用软件
pacman -S --noconfirm intel-ucode grub os-prober efibootmgr ntfs-3g exfat-utils pigz
pacman -S --noconfirm arch-install-scripts dhclient wget git zip unzip unrar p7zip
pacman -S --noconfirm yaourt proxychains
#pacman -S --noconfirm firefox google-chrome-dev
#设置开机自启动
#systemctl enable gdm
#systemctl enable NetworkManager
#添加用户
#reset
echo "请输入你的用户名："
read username
echo " 请输入用户密码："
read userpassword
echo "请输入root密码"
read rootpassword
useradd -m -g users -G wheel -s /bin/bash $username
echo "$username:$userpassword" | chpasswd
echo "root:$rootpassword" | chpasswd
sed -i "80s/$/&$username ALL=(ALL) ALL/g" /etc/sudoers



#更新引导
grub-mkconfig -o /boot/grub/grub.cfg
mkdir /f
mount $esp /f
grub-install --target=x86_64-efi --efi-directory=/f --bootloader-id=boot
umount /f

#设置环境变量
echo " export GTK_IM_MODULE=fcitx
 export QT_IM_MODULE=fcitx
 export XMODIFIERS=@im=fcitx" >> /home/$username/.xprofile
echo "alias gcl='git clone'
alias yaoins='yaourt -S '
alias gps='git push origin '
alias gco='git checkout'
alias pcq='proxychains -q'
alias pacins='yaourt -S'
alias sou='yaourt -Ss'
alias pacupd='yaourt -Syu'
alias shan='sudo rm -rf ./*'
alias gcl='git clone'
alias yaoins='yaourt -S '
alias gps='git push origin '
alias gco='git checkout'
alias pcs='baidupcs '
alias pacrm='yaourt -Rs '
alias sn='sudo nano '
alias n='nano '
alias sl='ls -la '
alias sysre='sudo systemctl restart '
alias syssta='sudo systemctl start '
alias syssto='sudo systemctl stop '
alias sysstu='sudo systemctl status '
alias sv='sudo vim '
alias cbot='sudo certbot certonly --email letencrypt@puzhou.org --webroot -w /var/lib/letsencrypt/ -d '" >> /home/$username/.bashrc

#安装自定义包
#pacman -U --noconfirm /diy/*




