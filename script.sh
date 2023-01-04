bucket=$1
aws s3 ls s3://$bucket/ > comparefile
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
            sed -i '$d' ./CloudToDoApp/backend/data/carrousel.json
            sed -i '$s/$/,/' ./CloudToDoApp/backend/data/carrousel.json
            echo "]" >> ./CloudToDoApp/backend/data/carrousel.json
            sed -i "/]/i \    {\"url\": \"https://$bucket.s3.amazonaws.com/$element\"}" ./CloudToDoApp/backend/data/carrousel.json
        fi
    done
    aws s3 ls s3://$bucket/ > s3
    echo $count
    if [ $count -gt 0 ]; then
        cd ./CloudToDoApp
        git switch sequelize
        docker-compose down
        docker-compose rm
        docker-compose build --no-cache
        docker-compose up
    fi
fi
