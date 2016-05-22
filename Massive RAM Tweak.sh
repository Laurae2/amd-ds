#Compressing RAM
#Allows to get more RAM than you'd ever try to get manually (especially if you reached your motherboard RAM limit)
#16GB RAM + 32GB swap using these tweaks can make 28GB RAM + 64GB swap while improving I/O
#Drawback: your CPU "might" be hogged even harder during heavy computation
#Don't even try using GPU as VRAM, not worth at all the issues you will have (xgboost freeze, etc.

#zram installation
sudo apt-get install zram-config
sudo reboot

#check if working
cat /proc/swaps

#if working, continue tuning
sudo gedit etc/init/zram-config.conf


#----------------------------------------------------
#Set NRDEVICES to the amount of RAM devices to use. Preferably the amount of CPU cores (NOT THREADS) you have.
#Set 6442450944 to the amount of RAM you want per device. Preferably keep below 80% of total RAM. 1073741824 = 1GB.
#Add as many echo/mkswap/swapon as there are devices. Or use the loop and edit it properly.
#-p 5 => swappiness 5


#----------------------------------------------------

description	"Initializes zram swaping"
author		"Adam Conrad <adconrad@canonical.com>"

start on runlevel [2345]

pre-start script
  # load dependency modules
  #NRDEVICES=$(grep -c ^processor /proc/cpuinfo | sed 's/^0$/1/')
  NRDEVICES=2
  if modinfo zram | grep -q ' zram_num_devices:' 2>/dev/null; then
    MODPROBE_ARGS="zram_num_devices=${NRDEVICES}"
  elif modinfo zram | grep -q ' num_devices:' 2>/dev/null; then
    MODPROBE_ARGS="num_devices=${NRDEVICES}"
  else
    exit 1
  fi
  modprobe zram $MODPROBE_ARGS

  # Calculate memory to use for zram (1/2 of ram)
  #totalmem=`free | grep -e "^Mem:" | sed -e 's/^Mem: *//' -e 's/  *.*//'`
  #mem=$(((totalmem / 2 / ${NRDEVICES}) * 1024))

  # initialize the devices
  #for i in $(seq ${NRDEVICES}); do
  #  DEVNUMBER=$((i - 1))
  #  echo $mem > /sys/block/zram${DEVNUMBER}/disksize
  #  mkswap /dev/zram${DEVNUMBER}
  #  swapon -p 5 /dev/zram${DEVNUMBER}
  #done
  # initialize the devices
  echo 6442450944 > /sys/block/zram0/disksize
  echo 6442450944 > /sys/block/zram1/disksize
  mkswap /dev/zram0
  mkswap /dev/zram1
  swapon -p 5 /dev/zram0
  swapon -p 5 /dev/zram1
end script

post-stop script
  if DEVICES=$(grep zram /proc/swaps | awk '{print $1}'); then
    for i in $DEVICES; do
      swapoff $i
    done
  fi
  rmmod -w zram
end script

#----------------------------------------------------

#reboot
sudo reboot

#check if working
cat /proc/swaps

#do zswap now
sudo gedit /etc/default/grub

#change the following line: GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
#to the following: GRUB_CMDLINE_LINUX_DEFAULT="quiet splash zswap.enabled=1"
#if you don't have "quiet splash", then GRUB_CMDLINE_LINUX_DEFAULT="zswap.enabled=1"
#if you have other things, then you just take GRUB_CMDLINE_LINUX_DEFAULT and add zswap.enabled=1 at the end with a space before

#update grub and reboot
update-grub
sudo reboot

#check if working
dmesg | grep zswap
