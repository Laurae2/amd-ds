# DO NOT RUN THIS BLINDLY
# CHECK WHAT YOU WANT
# CHECK WHAT YOU DON'T WANT
# RUN LINE BY LINE THE FIRST TIME
# MAKE YOUR OWN SCRIPT ONCE YOU FOUND EXACTLY WHAT YOU WANT
# REMEMBER TO ADD THE APPROPRIATE FLAGS WHEN MAKING YOUR OWN SCRIPT (-y etc...)


#Install Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update
sudo apt-get install google-chrome-stable

#Install gedit (Text Editor)
sudo apt-get install gedit gedit-plugins

#Install File Compression Libs
sudo apt-get install unace unrar zip unzip xz-utils p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller

#Install Guake Terminal
sudo apt-get install guake

#Install screenfetch (my elementary-OS special Version)
mkdir screenfetch
cd screenfetch
wget https://raw.github.com/memoryleakx/screenFetch/master/screenfetch-dev
sudo mv screenfetch-dev /usr/bin/screenfetch
cd ..
rm -rf screenfetch

#make it readable and executable
sudo chmod +rx /usr/bin/screenfetch

##setup .bashrc for auto screenfetch
gedit ~/.bashrc
###put this on the last line
screenfetch -D "Elementary"

#Install Ubuntu Restricted Extras
sudo apt-get install ubuntu-restricted-extras

#Enable all Startup Applications
cd /etc/xdg/autostart
sudo sed --in-place 's/NoDisplay=true/NoDisplay=false/g' *.desktop
cd ...

#Enable Movie DVD Support
sudo apt-get install libdvdread4
sudo /usr/share/doc/libdvdread4/install-css.sh

#Install a Firewall Application
sudo apt-get install gufw

#Install Gimp
sudo add-apt-repository ppa:otto-kesselgulasch/gimp
sudo apt-get update
sudo apt-get install gimp gimp-data gimp-plugin-registry gimp-data-extras

#Install the Dynamic Kernel Module Support Framework
sudo apt-get install dkms

#Install Java 7
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer

#Install PlayonLinux
#Run Windows Applications and Games on Linux
wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
sudo wget http://deb.playonlinux.com/playonlinux_precise.list -O /etc/apt/sources.list.d/playonlinux.list
sudo apt-get update
sudo apt-get install playonlinux

#Install Skype
sudo apt-add-repository "deb http://archive.canonical.com/ubuntu/ precise partner"
sudo apt-get update && sudo apt-get install skype

#Install Libre Office 4
sudo add-apt-repository ppa:libreoffice/libreoffice-5-1
sudo apt-get update
sudo apt-get install libreoffice

#Install the Clementine Music Player
sudo add-apt-repository ppa:me-davidsansome/clementine
sudo apt-get update
sudo apt-get install clementine

#Install VLC
sudo apt-get install vlc

#Install the latest git Version
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install git

#Install the latest Version of VirtualBox
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian precise contrib" >> /etc/apt/sources.list.d/virtualbox.list'
sudo apt-get update
sudo apt-get install virtualbox-4.3

#Install Thunderbird
sudo add-apt-repository ppa:ubuntu-mozilla-security/ppa
sudo apt-get update
sudo apt-get install thunderbird

#Install Psensor
sudo apt-get install lm-sensors hddtemp
sudo sensors-detect
sudo apt-get install psensor

#Install Transmission (torrent)
sudo apt-get install transmission

#Install Spotify
sudo apt-add-repository "deb http://repository.spotify.com stable non-free"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
sudo apt-get update
sudo apt-get install spotify-client

#Install dev tools
sudo apt-get install automake libtool gcc

#Install dconf-editor
sudo apt-get install dconf-editor

#Install lot of indicators
sudo apt-get install python-appindicator
sudo apt-get install mesa-utils
sudo apt-get install linux-tools-common
sudo apt-get install indicator-multiload
sudo apt-get install indicator-cpufreq

sudo add-apt-repository ppa:atareao/atareao
sudo apt-get update
sudo apt-get install my-weather-indicator

sudo add-apt-repository ppa:jconti/recent-notifications
sudo apt-get update
sudo apt-get install indicator-notifications

sudo add-apt-repository ppa:behda/ppa
sudo apt-get update
sudo apt-get install caffeine

sudo add-apt-repository ppa:alexmurray/indicator-sensors
sudo apt-get update
sudo apt-get install indicator-sensors

sudo add-apt-repository ppa:mpstark/elementary-tweaks-daily
sudo apt-get update
sudo apt-get install elementary-tweaks

#Install TLP freq tweak
sudo add-apt-repository ppa:linrunner/tlp
sudo apt-get update
sudo apt-get install tlp tlp-rdw
sudo tlp start

#Install Nemo without Cinnamon (for "big data browsing", plugins not necessary)
sudo add-apt-repository ppa:noobslab/mint
sudo apt-get update
sudo apt-get install nemo
sudo apt-get install nemo-compare nemo-dropbox nemo-fileroller nemo-pastebin nemo-seahorse nemo-share nemo-preview nemo-rabbitvcs

#Install powertop
sudo apt-get install powertop

#Install Glances: use glances -t 10
sudo apt-add-repository ppa:arnaud-hartmann/glances-stable
sudo apt-get update
sudo apt-get install glances
