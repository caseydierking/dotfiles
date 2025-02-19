#!/usr/bin/env bash

# Install command line tools
xcode-select -p
if [[ $? -ne 0 ]]; then
    xcode-select --install
fi

# A full installation of Xcode.app is required to compile macvim.
# Installing just the Command Line Tools is not sufficient.
xcodebuild -version
if [[ $? -ne 0 ]]; then
    # TODO: find a way to install Xcode.app automatticaly
    # See: http://stackoverflow.com/a/18244349

    # Accept Xcode license
    sudo xcodebuild -license
fi

# Update all OSX packages
sudo softwareupdate -i -a

# Install Homebrew if not found
brew --version
if [[ $? -ne 0 ]]; then
    # Clean-up failed Homebrew install
    rm -rf /usr/local/Cellar /usr/local/.git
    # Install Homebrew
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi
brew update
brew upgrade

# Include duplicates packages
brew tap homebrew/dupes

# Install Cask
brew tap caskroom/cask
brew install brew-cask

# Install OSX system requirements
brew install cask x-quartz

# Install a brand new Python
brew install python --with-brewed-openssl
brew link --overwrite python
sudo pip install --upgrade distribute

# Install common packages
brew install apple-gcc42
for PACKAGE in $COMMON_PACKAGES
do
   brew install $PACKAGE
done
brew install findutils
brew install bash
brew install ack
brew install grep
brew install rename
brew install tree
brew install webkit2png
brew install osxutils
brew install p7zip
brew install faad2
brew install bash-completion
brew install md5sha1sum
brew install ssh-copy-id
brew install colorsvn
brew install hub
brew install ack
brew install exiftool

# Install Cassandra
brew install cassandra
pip install cql

# htop-osx requires root privileges to correctly display all running processes.
sudo chown root:wheel /usr/local/bin/htop
sudo chmod u+s /usr/local/bin/htop

# Install binary apps
for PACKAGE in $BIN_PACKAGES
do
   brew cask install $PACKAGE
done
brew cask install dropbox
brew cask install f-lux
brew cask install gitx
brew cask install insync
brew cask install chromium
brew cask install libre-office
brew cask install tunnelblick
brew cask install bitcoin

# Install QuickLooks plugins
# Source: https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install qlprettypatch
brew cask install quicklook-csv
brew cask install betterzipql
brew cask install webp-quicklook
brew cask install suspicious-package
qlmanage -r

# Install vim
brew install lua --completion
brew install cscope
VIM_FLAGS="--with-python --with-lua --with-cscope --override-system-vim"
brew install macvim $VIM_FLAGS
brew install vim $VIM_FLAGS

# Install custom bootloader
curl -O http://kent.dl.sourceforge.net/project/refind/0.7.8/refind-bin-0.7.8.zip
unzip ./refind-bin-0.7.8.zip
./refind-bin-0.7.8/install.sh --yes
rm -rf ./refind-bin-0.7.8*
# Adjust refind config
sudo sed -i "" -e "s/timeout 20/timeout 1/" /EFI/refind/refind.conf
sudo sed -i "" -e "s/#default_selection 1/default_selection linux/" /EFI/refind/refind.conf

# Install steam in a case-insensitive disk image
# Source: http://blog.andersonshatch.com/2010/05/13/using-steam-on-mac-with-case-sensitive-drive/
if [! -e "~/steam.sparsebundle" ]; then
    brew install cask steam
    hdiutil create -size 30G -fs HFS+ -layout NONE -type SPARSEBUNDLE -volname steam ~/steam
    hdiutil mount ~/steam.sparsebundle
    cp -av /opt/homebrew-cask/Caskroom/steam/stable/Steam.app /Volumes/steam/
    mkdir /Volumes/steam/steam\ library /Volumes/steam/steam\ content
    ln -s /Volumes/steam/steam\ library ~/Library/Application\ Support/Steam
    sudo ln -s /Volumes/ /volumes
    brew cask uninstall steam
    # TODO: Find a way to create OSX alias to /Applications (to get automount)
    # See: https://en.wikipedia.org/wiki/Alias_(Mac_OS)
fi

# Install runsnakeerun
# Need to apply: https://github.com/Homebrew/homebrew/issues/23666#issuecomment-32453279
#brew install wxmac
#brew install wxpython
#pip install --upgrade RunSnakeRun

# Clean things up
brew linkapps
brew doctor
brew cleanup
