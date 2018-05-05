#count=10
#while [ 0 -lt $count ]; do
#    echo -e "\r$count"
#    ((count--))
#done

# https://qiita.com/mattintosh4/items/3ef2334631763986e724
# https://qiita.com/airtoxin/items/bb445529c94d3cd871f3
for ((i=0; i<=100; ++i))
{
    printf '\r%3d' $i
    sleep .04
}; printf '\n'
