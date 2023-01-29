#!/bin/bash
hostname="${HOSTNAME:-${hostname:-$(hostname)}}"

##############################
#	    DISK
##############################

#hdd() { free="$(df -h /home | grep /dev | awk '{print $3}' | sed 's/G/Gb/')" perc="$(df -h /home | grep /dev/ | awk '{print $5}')"
#     echo "$perc  ($free)"
#   }
##############################
#	    RAM
##############################

mem() {
used="$(free | grep Mem: | awk '{print $3}')"
total="$(free | grep Mem: | awk '{print $2}')"
human="$(free -h | grep Mem: | awk '{print $3}' | sed s/i//g)"

ram="$(( 200 * $used/$total - 100 * $used/$total ))% ($human)"
			echo "+@fg=7;[RAM:$ram]"
}
##############################
#	    CPU
##############################

cpu() {
	  read cpu a b c previdle rest < /proc/stat
	    prevtotal=$((a+b+c+previdle))
	      sleep 0.5
	        read cpu a b c idle rest < /proc/stat
		  total=$((a+b+c+idle))
		    cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
		    		echo "+@fg=8;[CPU:$cpu%]"
	    } 
##############################
#   VOLUME
##############################

vol() {
    VOL="$(amixer -D pipewire get Master | grep Left: | sed 's/[][]//g' | awk '{print $5}')"
    		echo "+@fg=5;[VOL:$VOL]"
	}
##############################
#	    Packages
##############################

#pkgs() {
	#pkgs="$(dpkg -l | grep -c ^i)"
	#echo "$pkgs"
#}
##############################
#	    UPGRADES
##############################

#upgrades(){
	#upgrades="$(aptitude search '~U' | wc -l)"
	#echo "$upgrades"
#}
##############################
#	    NETWORK
##############################
network() {
wire="$(ip a | grep "eth0\|enp" | grep inet | wc -l)"
wifi="$(ip a | grep wlan | grep inet | wc -l)"

if [ $wire = 1 ]; then
    echo "+@fg=1;[WIFI: ETH]"
elif [ $wifi = 1 ]; then
    echo "+@fg=1;[WIFI: UP ]"
else
    echo "+@fg=3;[WIFI:DOWN]"
fi

}

ipaddress() {
    address="$(ip a | grep .255 | grep -v wlp | cut -d ' ' -f6 | sed 's/\/24//')"
    echo "+@fg=0;[IP:$address]"
}

vpnconnection() {
    state="$(ip a | grep tun0 | grep inet | wc -l)"

if [ $state = 1 ]; then
    echo "+@fg=1;[VPN: UP ]"
else
    echo "+@fg=3;[VPN:DOWN]"
fi
}
# BATTERY
bat() {
battery="$(cat /sys/class/power_supply/BAT1/capacity)"
		echo "[$battery%]"
}

layout_info(){
   xset -q|grep LED| awk '{ if (substr ($10,5,1) == 1) print "RU"; else print "EN";}'
}
	while :; do
	      echo "$(layout_info)\
 $(bat)\
$(cpu)\
$(mem)\
$(vol)\
$(ipaddress)$(vpnconnection)\
$(network)\
"
        sleep 1
		done

