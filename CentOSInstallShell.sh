#mkdir /opt/centos-yum.bak
#mv /etc/yum.repos.d/* /opt/centos-yum.bak/
wget -O /etc/yum.repos.d/CentOS-Base-aliyun.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O CentOS-ustc.repo https://lug.ustc.edu.cn/wiki/_export/code/mirrors/help/centos?codeblock=3

#添加 rpmforge 源
#Remirepo：对于RHEL和CentOS，依赖关系位于主存储库和EPEL中。我强烈建议不要使用Rpmforge（臭名昭着的与EPEL不兼容）。
#官方声明：RepoForge可能已经过时了。很久以来我们没有更新。
#yum inntall http://repository.it4i.cz/mirrors/repoforge/redhat/el7/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm



#安装 ELRepo 源
#ELRepo包含了一些硬件相关的驱动程序，比如显卡、声卡驱动:
#http://elrepo.org/tiki/tiki-index.php
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

#添加 EPEL 仓库
#EPEL即Extra Packages for Enterprise Linux，为CentOS提供了额外的10000多个软件包，而且在不替换系统组件方面下了很多功夫，因而可以放心使用。
yum install -y https://mirrors.tuna.tsinghua.edu.cn/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm

#Remi
#Remi源大家或许很少听说，不过Remi源GoFace强烈推荐，尤其对于不想编译最新版的linux使用者，因为Remi源中的软件几乎都是最新稳定版。或许您会怀疑稳定不？放心吧，这些都是Linux骨灰级的玩家编译好放进源里的，他们对于系统环境和软件编译参数的熟悉程度毋庸置疑。
#https://rpms.remirepo.net/wizard/
#用于安装Remi存储库配置包的命令：
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils

#Nux Dextop
#Nux Dextop中包含了一些与多媒体相关的软件包，作者尽量保证不覆盖base源。官方说明中说该源与EPEL兼容，实际上个别软件包存在冲突，但基本不会造成影响:
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm


#添加adobe软件仓并导入密钥
rpm -ivh http://linuxdownload.adobe.com/linux/x86_64/adobe-release-x86_64-1.0-1.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux  

#添加 rpmfusion 源
#sudo yum localinstall --nogpgcheck http://mirrors.ustc.edu.cn/rpmfusion/free/el/rpmfusion-free-release-7.noarch.rpm http://mirrors.ustc.edu.cn/rpmfusion/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm

#安装yum-priorities插件
#这个插件是用来设置yum在调用软件源时的顺序的。因为官方提供的软件源，都是比较稳定和被推荐使用的。因此，官方源的顺序要高于第三方源的顺序。如何保证这个顺序，就需要安装yum-priorities这插件了。
yum install -y yum-priorities
#[base], [addons], [updates], [extras] … priority=1
#[CentOSplus],[contrib] … priority=2
#其他第三的软件源为：priority=N （推荐N>10）


yum clean all
yum makecache
yum install -y ntfs-3g
yum install -y ntfsprogs
yum install -y http://download1.rpmfusion.org/free/el/updates/7/x86_64/f/fuse-exfat-1.0.1-1.el7.x86_64.rpm
yum install -y http://download1.rpmfusion.org/free/el/updates/7/x86_64/e/exfat-utils-1.0.1-1.el7.x86_64.rpm

#scons和gcc
yum install -y scons gcc
#软件是fuse模块，编译需要fuse-devel包支持：
yum install -y fuse-devel

yum install -y cscope ctags screen grub-customizer ncurses-devel  openssl-devel gcc  gcc-c++

yum groupinstall -y "Development tools"
yum install -y gcc gcc-c++ gcc-g77 flex bison autoconf automake bzip2-devel zlib-devel ncurses-devel libjpeg-devel libpng-devel libtiff-devel freetype-devel pam-devel openssl-devel libxml2-devel gettext-devel pcre-devel
yum install -y kernel-devel.x86_64



#Chrome
yum install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm


#查看可用的系统内核包:
yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
#安装最新内核:
yum --enablerepo=elrepo-kernel install -y kernel-ml


#编辑 /etc/default/grub 文件
#设置 GRUB_DEFAULT=0，表示使用上一步的 awk 命令显示的编号为 0 的内核作为默认内核：

#设置 grub2 默认启动内核
grub2-set-default 0

#生成 grub 配置文件并重启
#grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
#grub2-mkconfig -o /boot/grub2/grub.cfg
#reboot


rpm -qa | grep kernel

#通过 yum-utils 工具删除多余内核
#如果安装的内核不多于 3 个，yum-utils 工具不会删除任何一个。只有在安装的内核大于 3 个时，才会自动删除旧内核。

#安装 yum-utils
yum install -y yum-utils
#删除内核
#package-cleanup --oldkernels


#安装播放器，解码器
#下载firefox的flash插件
yum install -y flash-plugin
#下载firefox的java插件
yum install -y icedtea-web
#安装 Handbrake、VLC 及 smplayer。
yum install -y vlc smplayer ffmpeg HandBrake-{gui,cli}
#安装播放某类媒体所需的解码器及译码器
yum install -y libdvdcss gstreamer{,1}-plugins-ugly \gstreamer-plugins-bad-nonfree gstreamer1-plugins-bad-freeworld

#安装adobe-source-code-pro-fonts字体
sudo yum -y install adobe-source-code-pro-fonts


echo -e "\n\n更新引导么?推荐!\n" 
read -p "Your input : " yn
if [[ "$yu" == "yes" ]]; then
	grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
	grub2-mkconfig -o /boot/grub2/grub.cfg
fi
echo -e "\n\n重启?推荐!\n" 
read -p "Your input : " yn
if [[ "$yu" == "yes" ]]; then
	reboot
fi


