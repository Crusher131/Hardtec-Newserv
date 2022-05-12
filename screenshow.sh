#!/bin/bash

echo "Servidor Instalado e configurado por"
echo -e "\033[38;2;0;0;255m"
echo -e "HH   HH   AAA   RRRRRR  DDDDD   TTTTTTT EEEEEEE  CCCCC  
HH   HH  AAAAA  RR   RR DD  DD    TTT   EE      CC    C 
HHHHHHH AA   AA RRRRRR  DD   DD   TTT   EEEEE   CC      
HH   HH AAAAAAA RR  RR  DD   DD   TTT   EE      CC    C 
HH   HH AA   AA RR   RR DDDDDD    TTT   EEEEEEE  CCCCC  "

echo -e "\033[m"
  echo -e "Hardtec.srv.br 47 3521-2335"
  cat /etc/redhat-release

printf "\n"
screenfetch
#Interfaces
INTERFACE=$(ip -4 ad | grep 'state UP' | awk -F ":" '!/^[0-9]*: ?lo/ {print $2}')

for x in $INTERFACE
do
        IP=$(ip ad show dev $x |grep -v inet6 | grep inet|awk '{print $2}')
        echo -e " \033[0m\033[1;33mIP: \033[m$IP"

done
GATEWAY=$(route -n|grep '^0.0.0.0'|awk '{print $2}')
        echo -e " \033[0m\033[1;33mGATEWAY: \033[m$GATEWAY"

DNS=$(cat /etc/resolv.conf|grep '^nameserver'|grep -v ':'|awk '{print $2}')
DNSNUMBER=1
for x in $DNS
do
        echo -e "\033[0m\033[1;33m DNS$DNSNUMBER: \033[m$x"
((DNSNUMBER=DNSNUMBER+1))
done




    echo -e "\033[0m\033[1;33m DISK: \033[m\n"
    df -lh |egrep '/dev/sd|/dev/mapper' |awk '{print $1,"\t" $6,"\t\t" $3,"/ " $4, "("$5")"}'

exit 0
