# rename a file to file.name
# where name is the login name of the user executing the script.

file=$1
set `who`
mv $file $file.$1