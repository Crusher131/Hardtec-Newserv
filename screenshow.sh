

#!/bin/sh
#
[ -r /etc/lsb-release ] && . /etc/lsb-release

if [ -z "$DISTRIB_DESCRIPTION" ] && [ -x /usr/bin/lsb_release ]; then
        # Fall back to using the very slow lsb_release utility
        DISTRIB_DESCRIPTION=$(lsb_release -s -d)
fi

screenfetch

echo -e "\033[38;2;0;0;255m"
echo "Servidor Instalado e configurado por"
echo -e " __  __     ______     ______     _____     ______   ______     ______    
/\ \_\ \   /\  __ \   /\  == \   /\  __-.  /\__  _\ /\  ___\   /\  ___\   
\ \  __ \  \ \  __ \  \ \  __<   \ \ \/\ \ \/_/\ \/ \ \  __\   \ \ \____  
 \ \_\ \_\  \ \_\ \_\  \ \_\ \_\  \ \____-    \ \_\  \ \_____\  \ \_____\ 
  \/_/\/_/   \/_/\/_/   \/_/ /_/   \/____/     \/_/   \/_____/   \/_____/ "
  echo -e "Hardtec.srv.br"
  cat /etc/redhat-release

echo -e "\033[m"

printf "\n"

#Interfaces
INTERFACE=$(ip -4 ad | grep 'state UP' | awk -F ":" '!/^[0-9]*: ?lo/ {print $2}')

printf "\n"
printf "Interface\tMAC Address\t\tIP Address\t\n"

for x in $INTERFACE
do
        MAC=$(ip ad show dev $x |grep link/ether |awk '{print $2}')
        IP=$(ip ad show dev $x |grep -v inet6 | grep inet|awk '{print $2}')
        printf  $x"\t\t"$MAC"\t"$IP"\t\n"

done
echo
UPDATES_COUNT=$(yum check-update --quiet | grep -v "^$" | wc -l)

if [[ $UPDATES_COUNT -gt 0 ]]; then
  echo "Updates available: ${UPDATES_COUNT}"
else
  echo "No packages marked for update"
fi
echo
