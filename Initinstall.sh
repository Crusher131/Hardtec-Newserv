#!/bin/bash

echo -e "\033[38;2;0;0;255m"
echo "Script desenvolvido por Jeferson Zacarias sens (Jeferson@hardtec.srv.br)"

echo -e "\033[m"

update=false
upgrade=false
basicpkg=false
loginscreen=false
loginscreenht=false
keys=false
askreboot=false
chrony=false
ip6=false
se=false
a=${@}
count=0
for var in "$@"
do
        if [ $var == "-U" ] || [ $var == "-u" ]; then
        upgrade=true
        elif [ $var == "-I" ] || [ $var == "-i" ]; then
        update=true
        elif [ $var == "-P" ] || [ $var == "-p" ]; then
        basicpkg=true
        elif [ $var == "-L" ] || [ $var == "-l" ]; then
        loginscreen=true
        elif [ $var == "-LH" ] || [ $var == "-lh" ] || [ $var == "-Lh" ] || [ $var == "-lH" ]; then
        loginscreenht=true
        elif [ $var == "-K" ] || [ $var == "-k" ]; then
        keys=true
        elif [ $var == "-C" ] || [ $var == "-c" ]; then
        chrony=true
        elif [ $var == "-6" ]; then
        ip6=true
        elif [ $var == "-S" ] || [ $var == "-s" ]; then
        se=true
        fi
        
        (( count++ ))
                    (( accum += ${#var} ))
done






UPDATE_PACKAGES(){
echo "Instalando Atualizações de pacotes"
yum update -y >> /dev/null
}

UPGRADE_OS(){
echo "Efetuando Upgrade do sistema"
yum upgrade -y >> /dev/null
}

BASIC_PACKAGES(){
    CHECKPACKAGES=(lsb_release hyperv-daemons bc epel-release vim-enhanced yum-utils iotop rsync htop screen screen curl wget rsync ntsysv samba acpid bc net-tools xinetd mtools speedtest-cli
mlocate ncdu tar)
    INSTALLPACKAGES=()
    INSTALLEDPACKAGES=()
echo "Limpando Cache"
yum clean all >> /dev/null
echo "Criando Cache Atualizado"
yum makecache >> /dev/null

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
    wget https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenfetch.sh -O /usr/bin/screenfetch >> /dev/null
    chmod +x /usr/bin/screenfetch
    wget https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenshow.sh -O /scripts/screenshow.sh >> /dev/null
    chmod +x /scripts/screenshow.sh
    if grep -Fxq "[ -z \"\$PS1\" ]  || /scripts/screenshow.sh" /etc/profile
then
printf ""
else
 echo "[ -z \"\$PS1\" ]  || /scripts/screenshow.sh">> /etc/profile
fi

}

CONFIGURE_LOGIN_SCREENHT() {
    wget https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenfetch.sh -O /usr/bin/screenfetch >> /dev/null
    chmod +x /usr/bin/screenfetch
    wget https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenshowht.sh -O /scripts/screenshowht.sh >> /dev/null
    chmod +x /scripts/screenshowht.sh
    if grep -Fxq "[ -z \"\$PS1\" ]  || /scripts/screenshowht.sh" /etc/profile
then
printf ""
else
 echo "[ -z \"\$PS1\" ]  || /scripts/screenshowht.sh">> /etc/profile
fi

}


TEC_KEYS() {
    echo "Verificando e adicionando keys ssh Para acesso"
rsa_pub_keys=(
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDP8FBf0qUvjgGxf2oqK0Ytgldi89ZBfQJXf8H8QCpLUCs9EU1AEv7zSmzo371Y+noUhA7t0x8/r7is6L+AfYhzBlhT88+f0TeRiS0uEB0RJLsyr9PLSMD6561OkSM60PjeHx53hiH2Osa0Joqbsd/8Ldf8nMQKIKsfL33J5tRa5CiNv46Hh1bwjmRyPvilDk5oYtK9oVjRtXA9IP4F8zc4SVM7T70ZRLO/ZSE86t8i4Y8WHBi3M5O88vbGE4dfiJl3EkvdmZccg5MZC+S/7NjJPCgqbSvRW8WCwNCZn9mtxsHQCrJCH8ckJMfpUdoBIlUt+DlJxlYvg3vySOJfVlZDEnyVrshTtqQYEaCFiQii0yYwTw51m+hqu7hRmVDixaOhpLDxe/P5pRkeD+BN+8cBPa/O+pyDQUr2NAbcZ6JEUTQHPsq1Yjkrnqa3RqpyS3XhC60cKhoGjgRykDDwUYIw84BKhTnbnyZ51XgwKJZ7tdwWHROJh8b/VUXwahSsWl0= jeferson@DESKTOP-8DOCJNF"
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
CHRONY_OK=$(rpm -qa |grep "chrony")
if [ "" = "$CHRONY_OK" ]; then
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



DISABLE_IPV6(){
ipv6_disable=(
    "net.ipv6.conf.all.disable_ipv6 = 1"
    "net.ipv6.conf.default.disable_ipv6 = 1"
)
    for i in "${ipv6_disable[@]}"
do
if grep -Fxq "$i" /etc/sysctl.conf
then
printf ""
else
    echo "Desabilitando IPV6"
    echo "$i" >> /etc/sysctl.conf
fi
done
sysctl -p >> /dev/null
echo "IPV6 Desabilitado"
}

DISABLE_SELINUX() {
        echo "Desabilitando SELINUX"
setenforce 0
if grep -Fxq "SELINUX=disabled" /etc/selinux/config
then
printf ""
else
      sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
fi
echo "SELINUX DESABILITADO"
}

CHECK_OS() {
if [ -f /etc/redhat-release ]; then
OS=`cat /etc/redhat-release`
echo "$OS"

else
echo "não"
fi
}


CHECK_OS
if [ $basicpkg == true ]; then
BASIC_PACKAGES
fi
CHECK_OS
if [ $update == true ]; then
UPDATE_PACKAGES
askreboot=true
fi
if [ $upgrade == true ]; then
UPGRADE_OS
askreboot=true
fi
CREATE_DIR
if [ $loginscreenht == true ]; then
CONFIGURE_LOGIN_SCREENHT
fi
if [ $loginscreen == true ]; then
CONFIGURE_LOGIN_SCREEN
fi
if [ $keys == true ]; then
TEC_KEYS
fi
if [ $chrony == true ]; then
INSTALL_CHRONY
fi
if [ $ip6 == true ]; then
DISABLE_IPV6
askreboot=true
fi
if [ $se == true ]; then
DISABLE_SELINUX
askreboot=true
fi
if [ $askreboot == true ]; then
echo "Algumas alterações Precisam da reinicialização do sistema para funcionar."
read -p "Deseja Reiniciar?(y,n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Reiniciando o Sistema"
    init 6
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
    else
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi
fi
