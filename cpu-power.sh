CMD=sensors -u | grep -A1 Esocket0: | tail -1 | grep -oP '(?<=\s)\d.+'

while :
do
  joules=$($CMD)
done
