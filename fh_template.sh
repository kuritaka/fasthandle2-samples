#!/bin/sh
########################################################
# Script name : fh_template.sh
# Description : shell script for xxxxxxx with fh command
# Author      : Takaaki Kurihara
#
# Help
#   fh_template.sh -h
#
#=======================================================
# rpm.sh show_argall
#
# fh -H host1 -f rpm.sh:xxxxx,yyyyy,zzzz
########################################################
VERSION="2021.04.21a"

func_usage_exit() {
cat <<HELP
Usage: fh_template.sh  [options]

Optins:
-h,--help       show this help message and exit
--version       show program's version number and exit
$(func_show_argall)


Usage with fh command:
  Execute Commnad in Local Host:
    fh -f fh_template.sh:arg1
    fh -f fh_template.sh:arg1,arg2

  Execute Command in Remote Host:
    fh -H host1 -f fh_template.sh:arg1
    fh -H host1 -f fh_template.sh:arg2

HELP
}

#=======================================================

echo "host : $(uname -n)"
echo 


func_show_argall (){
    ALL_FUNCTION=$(cat $0 |grep -e "(\s*)\s*{" |egrep -v "^#|func_" |awk -F\( '{ print $1 }')
    for ARG in $(echo $ALL_FUNCTION)
    do
        echo "$ARG"
    done
}


#=======================================================
# Basic Command
#=======================================================
#fh -H host1 -f fh_template.sh:arg1
arg1 () {
    echo "-----------"
    echo "test_start"
    echo 
    echo "arg1"
    echo 
    echo "test_end"
    echo "-----------"
}


arg2 () {
    echo "-----------"
    echo "test_start"
    echo 
    echo "arg2"
    echo 
    echo "test_end"
    echo "-----------"
}

#=======================================================
#FastHandle Function
#=======================================================
if [ "$#" -eq 0 ] ; then
    echo "Please specify an argument "
    echo 
    exit 1
fi

while [ "$#" -gt 0 ]
do
    #echo '$1' " = $1 : ALL ARGS =  $@"
    case $1 in
        -h | --help | show_argall )
            func_usage_exit
            exit 1
            ;;
        -V | --version)
            echo "Version : $VERSION"
            exit 1
            ;;
        *)
            echo $1
            $1
            ;;
    esac
    shift
done


echo
