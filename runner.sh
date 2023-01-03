bucket=$1
while true; do
  # Run the script
  ./script.sh $bucket
  # Wait 5 seconds before running the script again
  sleep 5
done
