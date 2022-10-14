cmd="sensors -u | grep -A1 Esocket0: | tail -1 | grep -oP '(?<=\s)\d.+'"
while :
do
  prevjoules=$(eval $cmd)
  sleep .5s
  joules=$(eval $cmd)
  echo $(echo "($joules - $prevjoules) / .5" | bc)
  prevjoules=$joules
done
