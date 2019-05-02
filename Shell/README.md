# **Unix shell programming tutorial.**

What is shell?

    shell is basically an interface that we interact with the unix kernel.

## **Basic commands:**

`who` command shows who is logged on.

    sreal    :0           2019-05-01 20:28 (:0)

`pwd` present working directory

    /home/sreal

`cal` displays a calendar and the data of the Easter

          May 2019        
    Su Mo Tu We Th Fr Sa  
             1  2  3  4  
    5  6  7  8  9 10 11  
    12 13 14 15 16 17 18  
    19 20 21 22 23 24 25  
    26 27 28 29 30 31   

-   cal 11 1990 
-   cal nov 1990

`data` print or set the system date and time

    Wed May  1 20:48:40 PDT 2019

`date  '+DATE:%m-%y%nTIME:%H:%M:%S'` show customized format.

    DATE:05-19
    TIME:20:52:40

`touch` change file timestamps(can be used to create files).

    touch test1 test2 test3

`mkdir` create directories.

    mkdir tmp
    mkdir tmp/dir1

`cd` change directory

    cd /home
    cd ~
    cd - # go back to previous dir.

`cat` concatenate files and print on standard output

    cat > test and Ctrl+d command to finish streaming in.
    cat file1 file2 > file3

`mv` move or rename file or directory.

    mv dir1 dir2 # rename(dir2 not exist) or move(dir2 exists)
    mv file1 file2 # rename
    mv file1 /dir1 # move

`rm` remove files or directories.

    rm dirs
    rm -rf dirs

`rmdir` remove empty directories.

    rmdir dir


`cp` copy files and directories.

    cp file dir/
    cp file1 file2
    cp dir1 dir2

`clear` clear the terminal screen.

    clear

`ln` make links between files.

    ln old new # hard link, make a replica. delete the old doesn't affect new
    ln -s old new # make a soft link delete old affects new.

`ls` list directory contents.

    ls # list contents 
    ls -l # list contents with long information format.
    ls -a # list all contents including the hidden files.

`chmod` change file mode bits.

    chmod 666 file # 4 for read, 2 for write, 1 for execute.
    chmod [ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+ files/dirs

`file` determine file type.

    file *

`wc` print new line, word, and byte counts for each file.

    wc file 
    wc -l file # lines
    wc -w file # words
    wc -m file # characters

`sort` sort lines of text files.

    sort # input contents and use Ctrl+d finished.
    sort file1 file2

`cat` remove sections from each line of files.

    cut -d"-" -f 1,3 players

`dd` convert and copy files.

    dd if=test of=put conv=ucase

`man` an interface to the on-line reference manuals.

    man man 
    man ${command}

`banner` print large banner.

    banner What is banner
    banner "What is banner"

`compress` compress and expand data.

    compress file
    compress -v file

`zcat` cat with zipped files.Z

    zcat file.Z

`uncompress` uncompress the zipped file.Z

    uncompress file.Z

`echo` display a line of text

    echo "Hello world"

## **Scripting**

`ss1.sh`

    # This is a hello world shell script.
    echo "Hello World"

`ss2.sh`

    # Order matters.
    pwd 
    ls -l
    banner "The End"

`ss3.sh`

    # read input as a variable.
    echo "Please enter your name"
    read my_name
    echo "Hello $my_name, It's a fine day."

`ss4.sh`

    # no need to specify the variable type.
    a=25
    echo $a
    a="This is the string format"
    echo $a

    # This file takes a file name as an argument and rename it.
    echo $0 $1 $2
    mv $1 $2
    cat $2

    # rename file with interactive mode.
    echo "Please enter the file name you wanted to rename."
    read ori_name
    echo "Please enter the new name."
    read new_name
    mv $ori_name $new_name
    cat $new_name

`ss5.sh`

    chmod 744 $1
    ls -l $1

    # use set command to set positional parameters.
    set a b c d e
    echo $1
    echo $2
    echo $3
    echo $4
    echo $5
    echo $*

`ss6.sh`

    # rename a file to file.name
    # where name is the login name of the user executing this script.
    file=$1
    set `who`
    mv $file $file.$1

`ss7.sh`

    # set `ls`  command can be replaced with * when run this command.
    echo The total number of items in the current directory is $#

`ss8.sh`

    # Arithmetic operation
    a=30 b=15
    expr $a + $b
    expr $a - $b
    expr $a \* $b
    expr $a / $b
    expr $a % $b
    expr $a \* \( $a + $b \) /$b

`ss9.sh`

    # Floating point Arithmetic
    a=10.5 b=3.5
    echo $a + $b | bc
    echo $a - $b | bc
    echo $a \* $b | bc
    echo $a / $b | bc
    echo $a % $b | bc

`ss10.sh`

    # Escape  sequences
    echo "a b c \nd e f"
    echo "oneee \rtwo"
    echo "one \ttwo"
    echo "one \btwo"
    echo "\033[1mBold\033[0m"
    echo "\033[7mHigh contrast\033[0m"
