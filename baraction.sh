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
			echo "+@fg=0;[+@fg=7;RAM:$ram+@fg=0;]"
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
		    		echo "+@fg=0;[+@fg=2;CPU:$cpu%+@fg=0;]"
	    } 
##############################
#   VOLUME
##############################

vol() {
    VOL="$(amixer -D pipewire get Master | grep Left: | sed 's/[][]//g' | awk '{print $5}')"
    		echo "+@fg=0;[+@fg=5;VOL:$VOL+@fg=0;]"
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
 
 #NETWORK
network() {
wire="$(ip a | grep "eth0\|enp" | grep inet | wc -l)"
wifi="$(ip a | grep wlan | grep inet | wc -l)"

if [ $wire = 1 ]; then
    echo "[+@fg=4;WIFI:ETH+@fg=0;]"
elif [ $wifi = 1 ]; then
    echo "[+@fg=1;WIFI:UP+@fg=0;]"
else
    echo "[+@fg=3;WIFI:DOWN+@fg=0;]"
fi
}

ipaddress() {
    address="$(ip a | grep .255 | grep -v wlp | cut -d ' ' -f6 | sed 's/\/24//')"
    echo "+@fg=0;[+@fg=8;IP:$address+@fg=0;]"
}

vpnconnection() {
    state="$(ip a | grep tun0 | grep inet | wc -l)"

if [ $state = 1 ]; then
    echo "[+@fg=1;VPN:UP+@fg=0;]"
else
    echo "[+@fg=3;VPN:DOWN+@fg=0;]"
	#echo "+@fg=3;[VPN:DOWN]"
fi
}
# BATTERY
bat() {
status="$(cat /sys/class/power_supply/BAT1/status)"
battery="$(cat /sys/class/power_supply/BAT1/capacity)"
	if [$status = 'Charging'];then	
		echo "+@fg=1;[+$battery%]"
	elif[$status = 'Discharging']
		echo "+@fg=0;[$battery%]"
	else 
		echo "+@fg=0;[$battery%]"
	fi
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

