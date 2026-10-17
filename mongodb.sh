#!/bin/bash


foldername="/etc/systemd/system/"
filename="servicefile.service"
logsfolder="/home/ec2-user/CartServices/"
logfilename=$0
configadrchange="sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf"
configfile="/etc/mongod.conf"

mkdir -p "${logsfolder}"
logfilefullname=$(touch ""${logsfolder}""${logfilename}"_$(date +%F-%S).txt")

validate_status(){

statuscode= $(echo $?)

if [ "$statuscode" -eq 0];
then 
echo "status code is "${statuscode}" ....proceed"   
else
echo "status code is "${statuscode}"....exit"
exit 1
 fi

} >> "$logfilefullname"
validate_status
user_id=$(id -u)
validate_status
cd "${foldername}"
validate_status
touch "$filename"
validate_status
echo "$MONGO_SERVICEFILE" >> "${foldername}""${filename}"  >> "$logfilefullname"
validate_status
# status=$(echo $?)  
# echo "$status"

change_address(){

if [ -f "$configfile" ];
then 
    echo ""$configadrchange""

    ""$configadrchange""
    validate_status

else
echo ""$configfile" is not present in the location...hence exit"
exit 1
fi 
}

mongodb_setup(){
    packagename=$1
dnf list installed "$packagename"
validate_status

# dnf search "$packagename" | grep "No matches found."

systemctl enable "$packagename"
validate_status
systemctl start "$packagename"
validate_status
systemctl status "$packagename"
validate_status
change_address
validate_status
systemctl restart "$packagename"
validate_status
netstat -lntp | grep 27017
validate_status


}

checkversion(){
packagename=$1

mongod --version
versionstatuscode=$(echo $?)
if [ "$versionstatuscode" -ne 0 ];
then
echo ""$packagename" is not installed so proceed"
else
echo ""$packagename" is  installed so please exit"
exit 1
}

for app in "${appname[@]}"
do
echo "$app"
packagename=$("echo $app")
validate_status
if [ "$packagename" = "mongodb-org" ];
do
checkversion "$packagename"
mongodb_setup "$packagename"
# elif [ "$packagename" = "redis:7" ]
# do
# redis
# else 
else
echo ""$packagename" is not equal to the given list we need to install"
exit 1
fi



