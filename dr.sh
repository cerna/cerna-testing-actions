x=1
while [ $x -le 10 ]
do
  eval python --versiono
  VALUE=$?
  echo "$VALUE"

  if [ $VALUE -eq 0 ]; then
    echo "eq 0"
    break
  fi
  echo "NN"
  x=$(( $x + 1 ))
done

python --versiono
echo "$?"