#!/bin/bash

# Pega o mês, dia e campo 8 (hora ou ano) do arquivo mais antigo em /etc
read mes dia ano_ou_hora <<< $(ls -lct /etc | tail -1 | awk '{print $6, $7, $8}')

# Função para converter mês português para inglês
convert_month() {
  case "$1" in
    jan) echo "Jan" ;;
    fev) echo "Feb" ;;
    mar) echo "Mar" ;;
    abr) echo "Apr" ;;
    mai) echo "May" ;;
    jun) echo "Jun" ;;
    jul) echo "Jul" ;;
    ago) echo "Aug" ;;
    set) echo "Sep" ;;
    out) echo "Oct" ;;
    nov) echo "Nov" ;;
    dez) echo "Dec" ;;
    *) echo "$1" ;;
  esac
}

mes_pt=$(echo $mes | tr '[:upper:]' '[:lower:]')
mes_en=$(convert_month $mes_pt)

# Verifica se o campo 8 é hora (contém ':') ou ano
if [[ "$ano_ou_hora" == *:* ]]; then
  # É hora, então o ano é o ano atual
  Ano=$(( $(date +%Y) ))
else
  # É ano, usa o ano do arquivo
  Ano=$ano_ou_hora
fi

# Monta a data completa
DataInstalacao="$mes_en $dia $Ano"

# Converte para timestamp
TimestampInstalacao=$(date -d "$DataInstalacao" +%s 2>/dev/null)

if [ -z "$TimestampInstalacao" ]; then
  echo "Erro ao converter a data de instalação: $DataInstalacao"
  exit 1
fi

TimestampAtual=$(date +%s)

# Calcula diferença em dias (valor absoluto para evitar negativo)
DiasPassados=$(( (TimestampAtual - TimestampInstalacao) / 86400 ))

if [ $DiasPassados -lt 0 ]; then
  DiasPassados=$(( -DiasPassados ))
fi


  cat /etc/redhat-release

printf "\n"
screenfetch
echo -e "\033[m\033[1;33m Servidor Linux instalado há: \033[m $DiasPassados dias ($dia/$mes/$Ano)"
#Interfaces
INTERFACE=$(ip -4 ad | grep 'state UP' | awk -F ":" '!/^[0-9]*: ?lo/ {print $2}')

for x in $INTERFACE
do
        IP=$(ip ad show dev $x |grep -v inet6 | grep inet|awk '{print $2}')
        echo -e " \033[0m\033[1;33mIP: \033[m$IP"

done
GATEWAY=$(ip route | grep '^default' | awk '{print $3}' | head -n1)
echo -e " \033[0m\033[1;33mGATEWAY: \033[m$GATEWAY"

DNS=$(cat /etc/resolv.conf|grep '^nameserver'|grep -v ':'|awk '{print $2}')
DNSNUMBER=1
for x in $DNS
do
        echo -e "\033[0m\033[1;33m DNS$DNSNUMBER: \033[m$x"
((DNSNUMBER=DNSNUMBER+1))
done




    echo -e "\033[0m\033[1;33m DISK: \033[m\n"
    df -lh |egrep '/dev/sd|/dev/mapper|/dev/nvm' |awk '{print $1,"\t" $6,"\t\t" $3,"/ " $4, "("$5")"}'

exit 0
