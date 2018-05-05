target=/tmp/work/chars.txt
echo "日本語を一文字ずつ表示する。この度はお疲れ様でした。" > $target
while IFS= read -rN1 char;
do
    printf "$char";
    sleep 0.05;
#done < $target
done < echo $target
