cmd="sensors -u | grep -A1 Esocket0: | tail -1 | grep -oP '(?<=\s)\d.+'"
prevjoules="${cmd[@]}"

while :
do
  sleep .5s
  joules="${cmd[@]}"
  echo $(echo "($joules - $prevjoules) / .5" | bc)
  prevjoules=$joules
done
