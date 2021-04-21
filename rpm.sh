#!/bin/sh
########################################################
# Script name : rpm.sh
# Description : shell script for install/uninstall rpm with fh command
# Author      : Takaaki Kurihara
#
# Help
#   rpm.sh -h
#
#=======================================================
# rpm.sh show_argall
#
# fh -H host1 -f rpm.sh:xxxxx,yyyyy,zzzz
########################################################
VERSION="2021.04.21a"

func_usage_exit() {
cat <<HELP
Usage: rpm.sh  [options]

Optins:

$(func_show_argall)


Usage with fh command:
  Execute Commnad in Local Host:
    fh -f rpm.sh:add_basic_centos7

  Execute Command in Remote Host:
    fh -H host1 -f rpm.sh:add_basic_centos7

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
#fh -H host1 -f user.sh:add_basic_centos7
add_basic_centos7 () {
    rpm -q epel-release      > /dev/null 2>&1 || yum -y install epel-release
    rpm -q bash-completion   > /dev/null 2>&1 || yum -y install bash-completion
    rpm -q traceroute        > /dev/null 2>&1 || yum -y install traceroute
    rpm -q vim-enhanced      > /dev/null 2>&1 || yum -y install vim-enhanced
    rpm -q tree              > /dev/null 2>&1 || yum -y install tree
    rpm -q telnet            > /dev/null 2>&1 || yum -y install telnet
    rpm -q bind-utils        > /dev/null 2>&1 || yum -y install bind-utils
    rpm -q tcpdump           > /dev/null 2>&1 || yum -y install tcpdump
    rpm -q sysstat           > /dev/null 2>&1 || yum -y install sysstat
    rpm -q tcpdump           > /dev/null 2>&1 || yum -y install tcpdump
    rpm -q net-snmp          > /dev/null 2>&1 || yum -y install net-snmp
    rpm -q net-snmp-utils    > /dev/null 2>&1 || yum -y install net-snmp-utils
    rpm -q wget              > /dev/null 2>&1 || yum -y install wget
    rpm -q rsync             > /dev/null 2>&1 || yum -y install rsync
    rpm -q nmap              > /dev/null 2>&1 || yum -y install nmap
    rpm -q net-tools         > /dev/null 2>&1 || yum -y install net-tools
    rpm -q mailx             > /dev/null 2>&1 || yum -y install mailx
    rpm -q nmap-ncat         > /dev/null 2>&1 || yum -y install nmap-ncat
    rpm -q ccze              > /dev/null 2>&1 || yum -y install ccze #log color
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
