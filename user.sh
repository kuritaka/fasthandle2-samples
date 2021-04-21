#!/bin/sh
###########################################################
# Script name : user.sh
# Description : user management shell script with fh command
# Author      : Takaaki Kurihara
#
# Help
#   user.sh -h
#
############################################################
VERSION="2021.04.21a"

func_usage_exit() {
cat <<HELP
Usage: user.sh  [options]

Optins:

$(func_show_argall)


Usage with fh command:
  Execute Commnad in Local Host:
    fh -f user.sh:check_user
    fh -f user.sh:check_group

  Execute Command in Remote Host:
    fh -H host1 -f user.sh:check_user
    fh -H host1 -f user.sh:check_group,check_user


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
# Check
#=======================================================
#fh -H host1 -f user.sh:check_group
check_group (){
    echo "# cat /etc/group |tail -n 20"
    cat /etc/group |tail -n 20
}

#fh -H host1 -f user.sh:check_user
check_user (){
    echo "# cat /etc/passwd |grep /home/"
    cat /etc/passwd |grep /home/
}

#=======================================================
# GROUP
#=======================================================
func_groupadd (){
    group $GNAME > /dev/null
    if [ "$?" -ne 0 ] ; then
        echo "[Info] groupadd  $GID $GNAME"
        #groupadd  $GID $GNAME
    fi
}

func_groudel (){
    group $GNAME > /dev/null
    if [ "$?" -eq 0 ] ; then
        echo "[Info] groudel $GNAME"
        #groupdel $GNAME
    fi
}

##### add group #####

#fh -H host1 -s -f user.sh:groupadd_testgroup1
groupadd_testgroup1 (){
    GNAME="testgroup1"
    GID="-g 1100"

    func_groupadd
}


##### del group #####

groupdel_testgroup1 (){
    GNAME="testgroup1"  ;  func_groupdel
}


#=======================================================
# Password
#=======================================================
func_chpasswd (){
    id $UNAME > /dev/null
    if [ "$?" -eq 0 ] ; then
        echo "[Info] password change $UNAME"
        echo ${UNAME}:${UPASS} | chpasswd
    fi

}

#fh -H host1 -s -f user.sh:chpasswd_testuser1
chpasswd_testuser1 (){
    UNAME="testuser1"
    UPASS="testpass"

    func_chpasswd
}




#=======================================================
# USER
#=======================================================
func_useradd (){
    id $UNAME
    if [ "$?" -ne 0 ] ; then
        echo "[Info] useradd -m $USERID $USHELL $UGROUP1 $UGROUP2 $UNAME"
        useradd -m $USERID $USHELL $UGROUP1 $UGROUP2 $UNAME
        id $UNAME
    else
        echo "[Info] There are already user. $UNAME"
    fi
}

func_userdel (){
    id $UNAME
    if [ "$?" -eq 0 ] ; then
        echo "[Info] userdel -r $UNAME"
        userdel -r $UNAME
    fi
}


##### add Individual User #####

#fh -H host1 -s -f user.sh:useradd_testuser1
useradd_testuser1 (){
    #test centos admin user
    UNAME="testuser1"
    #UGROUP1="-g dev"
    UGROUP2="-G wheel"
    USERID="-u 1101"
    USHELL="-s /bin/bash"

    func_useradd
}

useradd_testuser2 (){
    #test ubuntu admin user
    UNAME="testuser2"
    UGROUP="-G sudo"
    USERID="-u 1102"
    USHELL="-s /bin/bash"

    func_useradd
}

##### add multiplue user #####
useradd_test_all (){
    useradd_testuser1
    useradd_testuser2
}

##### multiplue user #####
userdell_left_company (){
    UNAME="testuser1"   ; func_userdel
    UNAME="testuser2"   ; func_userdel
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
