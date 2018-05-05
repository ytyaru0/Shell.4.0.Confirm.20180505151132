# https://stackoverflow.com/questions/1494178/how-to-define-hash-tables-in-bash?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa

declare -A test=(
    [y]=1
    [n]=2
    [o]=3
    [c]=4
)
echo ${!test[@]}
echo ${test[y]}
echo '***************'
declare -A Confirm=(
    [y]=\([code]=0 [label]=yes    [method]="echo YES!!"\)
    [n]=\([code]=1 [label]=no     [method]="echo YES!!"\)
)
echo ${!Confirm[@]}
echo ${Confirm[y]}
echo '***************'
declare -A Yes=([code]=0 [label]=yes    [method]="echo YES!!")
declare -A No=([code]=1 [label]=no      [method]="echo No...")
declare -A Confirm=(
    [y]=$Yes
    [n]=$No
)
echo ${!Confirm[@]}
echo ${Confirm[y]}
echo '***************'
declare -A Confirm=(
    [y]=([code]=0 [label]=yes    [method]="echo YES!!")
    [n]=([code]=1 [label]=no     [method]="echo YES!!")
    [o]=([code]=0 [label]=ok     [method]="echo YES!!")
    [c]=([code]=2 [label]=cancel [method]="echo YES!!")
)
echo ${!Confirm[@]}
echo ${Confirm[y]}
echo ${Confirm[y[code]]}
