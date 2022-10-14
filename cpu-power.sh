prevjoules=0.0

while :
do
  joules=$(sensors -u | grep -A1 Esocket0: | tail -1 | grep -oP '(?<=\s)\d.+')
  echo $joules
  echo $(($joules - $prevjoules))
  prevjoules=$joules
done
