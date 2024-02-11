SIG=$(tail -n1 /proc/net/wireless | awk '{ print $4 }' | sed 's/\.//')

if [ "$SIG" -ge -30 ]
then
  COLOR="6699ff"
elif [ "$SIG" -ge -67 ]
then
  COLOR="00ff00"
elif [ "$SIG" -ge -70 ]
then
  COLOR="ffff00"
elif [ "$SIG" -ge -80 ]
then
  COLOR="ff9900"
elif [ "$SIG" -ge -90 ]
then
  COLOR="ff0000"
else
  COLOR="ff00ff"
fi

echo "<fc=#$COLOR>${SIG}dBm</fc>"
