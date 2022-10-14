CMD="sensors -u | grep -A1 Esocket0: | tail -1 | grep -oP '(?<=\s)\d.+'"
prevjoules=$($CMD)

while :
do
  sleep .5s
  joules=$($CMD)
  echo $(echo "($joules - $prevjoules) / .5" | bc)
  prevjoules=$joules
done
