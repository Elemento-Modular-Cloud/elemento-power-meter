cmd="sensors -u | grep -A1 Esocket0: | tail -1 | grep -oP '(?<=\s)\d.+'"
prevjoules=eval $cmd

while :
do
  sleep .5s
  joules=eval $cmd
  echo $(echo "($joules - $prevjoules) / .5" | bc)
  prevjoules=$joules
done
