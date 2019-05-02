# Unix shell programming tutorial.

What is shell?

    shell is basically an interface that we interact with the unix kernel.

## Basic commands:

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

