#!/bin/sh

PS_LED=377
PS_KEY=373
PL_LED=507
PL_KEY=510

#set up LED gpio
if [[ ! -e /sys/class/gpio/gpio"$PS_LED" ]];then
	echo $PS_LED >> /sys/class/gpio/export 
	echo out >> /sys/class/gpio/gpio"$PS_LED"/direction
fi

if [[ ! -e /sys/class/gpio/gpio"$PL_LED" ]];then
        echo $PL_LED >> /sys/class/gpio/export
	echo out >> /sys/class/gpio/gpio"$PL_LED"/direction
fi

#set up KEY gpio
if [[ ! -e /sys/class/gpio/gpio"$PS_KEY" ]];then
        echo $PS_KEY >> /sys/class/gpio/export
fi
echo in >> /sys/class/gpio/gpio"$PS_KEY"/direction

if [[ ! -e /sys/class/gpio/gpio"$PL_KEY" ]];then
        echo $PL_KEY >> /sys/class/gpio/export
fi
echo in >> /sys/class/gpio/gpio"$PL_KEY"/direction

#push PS_KEY to contorl PS_LED
#push PL_KEY to contorl PL_LED
PS_LED_STS=0
PL_LED_STS=0

echo -e "\e[1;32mLEDs and KEYs set OK, now you can click the KEYs to light up or turn off the LEDs\e[0m"

while ((1))
do
	#read key value
	PS_KEY_STS=`cat /sys/class/gpio/gpio"$PS_KEY"/value`
	PL_KEY_STS=`cat /sys/class/gpio/gpio"$PL_KEY"/value`
	if [ $PS_KEY_STS -eq 0 ];then
		PS_LED_STS=$((!PS_LED_STS))
		#set led out value
		echo $PS_LED_STS >> /sys/class/gpio/gpio"$PS_LED"/value
		while (($((!PS_KEY_STS))))
		do
			#wait key release
			PS_KEY_STS=`cat /sys/class/gpio/gpio"$PS_KEY"/value`
		done
	fi
	if [ $PL_KEY_STS -eq 0 ];then
                PL_LED_STS=$((!PL_LED_STS))
		echo $PL_LED_STS >> /sys/class/gpio/gpio"$PL_LED"/value
		while (($((!PL_KEY_STS))))
                do
                        PL_KEY_STS=`cat /sys/class/gpio/gpio"$PL_KEY"/value`
                done

	fi

done



