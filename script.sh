aws s3 ls s3://my-s3-bucket12345678985277/ > comparefile
cmp s3 comparefile > output
if [ -s output ]; then
    cut -d' ' -f9 comparefile > images
    var=$(cat images)
    arr=($(echo "$var" | tr ' ' '\n'))
    count=0
    echo "${arr[@]}"
    for element in ${arr[@]}; do
        if grep -q $element s3; then
            :
        else
            let count=count+1
            sed -i "/]/i \    {\"url\": \"https//my-s3-bucket12345678985277.s3.amazonaws.com/$element\"}" ./CloudToDoApp/backend/data/carrousel.json
        fi
    done
    aws s3 ls s3://my-s3-bucket12345678985277/ > s3
    echo $count
    if [ $count -gt 0 ]; then
        docker-compose down
        docker-compose rm
        cd ./CloudToDoApp
        docker-compose build --no-cache
        docker-compose up -d
    fi
fi
