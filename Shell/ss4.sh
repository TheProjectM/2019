# no need to specify the variable type.
# a=25
# echo $a
# a="This is string format"
# echo $a

# This file takes a file name as an argument and rename it.
# mv $1 $2
# cat $2

# rename file with interactive mode.

echo "Please enter the file name you wanted to rename."
read ori_name
echo "Please enter the new name"
read new_name
mv $ori_name $new
cat $new_name