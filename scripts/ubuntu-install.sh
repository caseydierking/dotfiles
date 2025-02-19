#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install aptitude

sudo add-apt-repository -y ppa:sunab/kdenlive-svn
sudo add-apt-repository -y ppa:bitcoin/bitcoin

sudo aptitude update
sudo aptitude upgrade -y


# Install common packages
sudo aptitude install -y $COMMON_PACKAGES $BIN_PACKAGES

# Install Ubuntu specific packages
sudo aptitude install -y mkvtoolnix-gui mbr hfsprogs hfsplus subtitlecomposer deborphan \
chromium-browser kompare avidemux-common transcode mkvtoolnix mencoder mplayer gitg bleachbit \
p7zip-full gtk-chtheme gnome-themes-standard faad h264enc kwrite kscreensaver \
hunspell-fr hunspell-fr-classical gimp-plugin-registry xscreensaver xscreensaver-data \
xscreensaver-data-extra xscreensaver-gl xscreensaver-gl-extra network-manager-openvpn ksshaskpass \
qemu-kvm dmg2img pdftk chromium-codecs-ffmpeg-extra picard xsltproc xfsprogs lm-sensors bzrtools \
ntp ca-certificates apt-file kdenlive gtk2-engines unclutter driftnet \
vim-nox ttf-ancient-fonts kdesdk-scripts cpufrequtils sysfsutils powertop sqlitebrowser \
efibootmgr ack-grep libimage-exiftool-perl subsurface bitcoin-qt

sudo aptitude install -y python-pip python-dev runsnakerun
sudo pip install --upgrade distribute

sudo gem install hub


sudo aptitude install -y virt-manager
sudo usermod -a -G libvirtd kevin
sudo usermod -a -G kvm kevin


sudo aptitude install -y redshift gtk-redshift geoclue


sudo aptitude install -y libavcodec-extra-53


# Install GMVault
sudo pip install --upgrade https://pypi.python.org/packages/source/g/gmvault/gmvault-1.8.1-beta.tar.gz#md5=a0b26d814506748deca8e2eee4086b31


# Install Pelican and its dependencies
sudo aptitude install -y python-markdown python-pygments python-beautifulsoup pandoc \
python-smartypants s3cmd
sudo pip install --upgrade pelican mdx_video typogrify Fabric


# Install Dropbox if not already there
[ ! -f ~/.dropbox-dist/dropbox ] && wget -O - "http://www.dropbox.com/download?plat=lnx.x86_64" | tar -xvz --directory ~ -f -


# Install google music manager
wget "https://dl.google.com/linux/direct/google-musicmanager-beta_current_amd64.deb"
sudo dpkg -i ./google-musicmanager-beta_current_amd64.deb
rm ./google-musicmanager-beta_current_amd64.deb


# Install insync
wget -qO - https://d2t3ff60b2tol4.cloudfront.net/services@insynchq.com.gpg.key | sudo apt-key add -
# TODO: don't add twice if config line already there
sudo tee -a /etc/apt/sources.list <<-EOF
    deb http://apt.insynchq.com/ubuntu saucy non-free contrib
EOF
sudo aptitude update
sudo aptitude install -y insync insync-dolphin


# Install Steam
sudo dpkg --add-architecture i386
sudo aptitude update
sudo aptitude install -y steam mesa-utils
# Install xbox gamepad support
# See: http://29a.ch/2013/2/24/xbox-controller-with-ubuntu-steam-xboxdrv
sudo aptitude install -y xboxdrv
sudo -E bash -c "echo 'blacklist xpad' > /etc/modprobe.d/blacklist.conf"
sudo rmmod xpad


# Install Popcorn Time
[ ! -d ~/Popcorn-Time ] && wget -O - "http://cdn.get-popcorn.com/build/Popcorn-Time-0.2.9-Linux-64.tar.gz" | tar -xvz --directory ~ -f -
[ ! -f /lib/x86_64-linux-gnu/libudev.so.0 ] && sudo ln -s /lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libudev.so.0


# Clean-up
sudo aptitude remove -y akregator kaddressbook knotes kontact korganizer dragonplayer kamera kcalc \
kaccessible kdegraphics-strigi-analyzer kmag kpat rekonq quassel kmail unity-gtk2-module \
unity-gtk3-module kde-telepathy telepathy-logger telepathy-indicator telepathy-salut \
kde-config-telepathy-accounts kde-telepathy-approver kde-telepathy-data telepathy-gabble \
libtelepathy-logger3 libtelepathy-glib0 libtelepathy-qt4-2

sudo apt-file update

sudo deborphan | xargs sudo apt-get -y remove --purge
sudo apt-get -y autoremove
