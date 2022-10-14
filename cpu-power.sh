prevjoules=0.0

while :
do
  sleep .5s
  joules=$(sensors -u | grep -A1 Esocket0: | tail -1 | grep -oP '(?<=\s)\d.+')
  echo $(echo "($joules - $prevjoules) / .5" | bc)
  prevjoules=$joules
done
