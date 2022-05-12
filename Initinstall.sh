#!/bin/bash

echo -e "\033[38;2;0;0;255m"
echo "Script desenvolvido por Jeferson Zacarias sens (Jeferson@hardtec.srv.br)
para CentOS 7"
echo -e " __  __     ______     ______     _____     ______   ______     ______    
/\ \_\ \   /\  __ \   /\  == \   /\  __-.  /\__  _\ /\  ___\   /\  ___\   
\ \  __ \  \ \  __ \  \ \  __<   \ \ \/\ \ \/_/\ \/ \ \  __\   \ \ \____  
 \ \_\ \_\  \ \_\ \_\  \ \_\ \_\  \ \____-    \ \_\  \ \_____\  \ \_____\ 
  \/_/\/_/   \/_/\/_/   \/_/ /_/   \/____/     \/_/   \/_____/   \/_____/ "
  echo -e "Hardtec.srv.br"
  

echo -e "\033[m"

BASIC_PACKAGES(){
    CHECKPACKAGES=(epel-release vim-enhanced yum-utils iotop rsync htop screen screen curl wget rsync httpd-tools ntsysv samba acpid)
    INSTALLPACKAGES=()
    INSTALLEDPACKAGES=()
echo "Limpando Cache"
#yum clean all >> /dev/null
#echo "Criando Cache Atualizado"
#yum makecache >> /dev/null
echo "Instalando Atualizações"
#yum update -y >> /dev/null
#yum upgrade -y >> /dev/null
echo "Verificando pacotes basicos"
for i in "${CHECKPACKAGES[@]}"
do
PACOTE_OK=$(rpm -qa |grep "$i")
if [ "" = "$PACOTE_OK" ]; then
    INSTALLPACKAGES[${#INSTALLPACKAGES[@]}]="$i"
  else
  INSTALLEDPACKAGES[${#INSTALLEDPACKAGES[@]}]="$i"
fi
done
printf "\nPacotes Já instalados: "
for i in "${INSTALLEDPACKAGES[@]}"
do
printf "$i "
done
printf "\nPacotes para serem instalados: "
for i in "${INSTALLPACKAGES[@]}"
do
printf "$i "
done
printf "\n"

echo "Iniciando Instalação"
for i in "${INSTALLPACKAGES[@]}"
do
printf "$i: "
yum install "$i" -y >> /dev/null
if [ $? -eq 0 ]
then
printf "Instalado\n"
else
printf "ERRO\n"
fi
done
}

CREATE_DIR() {
    if [ ! -d "/scripts" ]; then
    mkdir /scripts
fi
}


CONFIGURE_LOGIN_SCREEN() {
    wget https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenfetch.sh -O /usr/bin/screenfetch
    chmod +x /usr/bin/screenfetch
    wget https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenshow.sh -O /scripts/screenshow.sh
    hmod +x /scripts/screenshow.sh
    if grep -Fxq "[ -z \"\$PS1\" ]  || /scripts/screenshow.sh" /etc/profile
then
printf ""
else
 echo "[ -z \"\$PS1\" ]  || /scripts/screenshow.sh">> /etc/profile
fi

}



TEC_KEYS() {
    echo "Verificando e adicionando keys ssh Para acesso"
rsa_pub_keys=(
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZPKqU6ARBmM7nVTeWBoVb3505XpyeS6AIYQI47muYBP/hODX+oIWgR2qYfkPZ5US5iRUan/EGmhL1OfnpWU3ollfV1JMNEdOv/mFineEWyYNdcSqqE4Fbi1+K/N4/Xk0Dpqa3ZscxojQ0HpcqtDcz8pwS/dU6McqA3E8DPhdcOnXVGiUWL5WAhNxwu/+28GHKb7xRljFtolLPrlM03jqUnZJXg1BdDRmSYInUVdFGshiiLmUi4as/Y3emxb5l+yPM3e7SMZbWrHiH4u46GoEC8TsJ3K66PnZE9cV2W7my2TNxgVngq/5SU0XoWkKvJqghLdkg2dOiSqtFgdlOQ9IfUoZkLAof34oP8H4kxX7F+Ifrg32whnyRwMmaiTpNu/ztSiJCp/SIXBnHGdgsCv1G5/wne/FsOmHJXv/A2xma9YT+nnibAYwcyhQ0xLUl8NvHhbEbHUY052slwGDo2dec0mu53GlVrmXT65+1r0TjSXVTXmnwdiSvegz2C1AtsbU= jeferson sens@DESKTOP-AN610C8"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKAYMXdOQnBY/ZOUNp1/Gm5Cy1xfvWRdFLzSGKsP80blFtq3xmSACZr0VeHTVttri6Q8fJqIgi9/YnsdgzFRuad2DTb7aujc/fvqJk+2CSzdw58XKszoqPPG40y3DK9I3xptuVeaLaWQdwwQcWtqjyyZdOUfc2FGKD9pVSoZSwA8dDyV9yvqNrCrj3aSFrYtv/U4N4ePDAyabwOt3WIZ7DUk2AigasuxEJi37Lw9tkPdvfFzuMFaOVGV16r0sObaCOgmFTMNSMApMVgRyiNzGSNFmv144sEy+M8WxyAV3o7JxOA7ZQEddn5tVXFpGTR4vxUFk+x+hjzKuQjuQibkPT junior@junior.hardtec.local"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4VwisCopOIpzNMS5W1V4+SmQTC5X5h6+eb3LZWss7yvSOEUK+1qWhibVmDRIgfMLqjSB7J9g2PyZwFFKTqt0nz1UTP4U5NV8Gns0iCRIt449kNSSX8jkBw3eTS2NGA14q/IIL0DhYYoY46uazG0qoBdycdRDPTUVcYhM2JgdXZW0dldb/FsU7ZPzZ+rNwN4YNKdjkWRRe6l64KQ58aoItxyl9KVqo1SLJgDj4JbQdAIhdpP1DIcIYNMXHBaxP6LxkTMrVSVRIHcxXBLrMaDKc2HeuLksvSL7QAC1g1rvj5+ksd9/IAPs2L17goSj9MpD6CWZ70MY4VsLzQM7QFMjSNy7NLA598qonDM7aPuuTrUkx2vXfCXB5Cf8doW8SCG1iDH/IZt+jObZyt/FiQl/u09yya/nqXCvoXk/aWUcAom1EGWS7RQD/mgOCZjuv/8xYh6nkO+K+zyEepdYQeaMhmPohfZv/mbd/eL+3qgvKclbsGtFyWf98EDfz9FQhHE0= claudio@Note-Claudio"
)
if [ ! -d "/root/.ssh" ]; then
    mkdir /root/.ssh
fi
if [ ! -f "/root/.ssh/authorized_keys" ]; then
    touch /root/.ssh/authorized_keys
fi


for i in "${rsa_pub_keys[@]}"
do
if grep -Fxq "$i" /root/.ssh/authorized_keys
then
echo "Key Já instalada"
else
    echo "Instalando key"
    echo "$i" >> /root/.ssh/authorized_keys
fi
done

}


INSTALL_CHRONY() {
echo "Instalando Chrony"
PACOTE_OK=$(rpm -qa |grep "chrony")
if [ "" = "$PACOTE_OK" ]; then
  echo " Instalando Chrony."
  yum install chrony -y >> /dev/null
  echo "Chrony: Instalado!"
  else
  echo "Chrony: Instalado!"
fi


echo "Configurando Serviço Chrony para usar Pool NTP.br"
sed -i 's/^[^#]*server*/#&/' /etc/chrony.conf
echo "#Servidores Adicionados HTCHAT" >> /etc/chrony.conf
ntp_servers=(
    "server a.st1.ntp.br iburst"
    "server b.st1.ntp.br iburst"
    "server c.st1.ntp.br iburst"
    "server d.st1.ntp.br iburst"
    "server gps.ntp.br iburst"
    )

for i in "${ntp_servers[@]}"
do
if grep -Fxq "$i" /etc/chrony.conf
then
echo ""
else
    echo "$i" >> /etc/chrony.conf
fi
done

systemctl start chronyd >> /dev/null
if [ $? -eq 0 ]
then
echo "Serviço Chronyd Iniciado"
else
echo "Erro ao iniciar o Chronyd"
fi

systemctl enable chronyd >> /dev/null
if [ $? -eq 0 ]
then
echo "Serviço Chronyd Adicionado a inicialização"
else
echo "Erro ao adicionar chrony a inicialização"
fi
}



BASIC_PACKAGES
CREATE_DIR
CONFIGURE_LOGIN_SCREEN
TEC_KEYS
INSTALL_CHRONY
