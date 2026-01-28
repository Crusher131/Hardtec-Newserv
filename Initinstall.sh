#!/bin/bash

# Detecta o gerenciador de pacotes
detect_pkg_manager() {
    if command -v dnf >/dev/null 2>&1; then
        PKG_MGR="dnf"
    elif command -v yum >/dev/null 2>&1; then
        PKG_MGR="yum"
    else
        PKG_MGR=""
    fi
}

# =============================
#       OPÇÃO 1 - UPDATE
# =============================
do_update() {
    detect_pkg_manager
    
    if [ -z "$PKG_MGR" ]; then
        whiptail --title "Erro" --msgbox "Nenhum gerenciador (dnf/yum) encontrado!" 8 60
        return 1
    fi

    sudo -v || { 
        whiptail --title "Erro" --msgbox "Preciso de sudo para atualizar." 8 60
        return 1
    }

    if [ "$PKG_MGR" = "dnf" ]; then
        (sudo dnf -y upgrade >/dev/null 2>&1) &
    else
        (sudo yum -y update >/dev/null 2>&1) &
    fi
    pid=$!

    (
        p=0
        while kill -0 "$pid" 2>/dev/null; do
            echo "$p"
            p=$(( (p + 3) % 100 ))
            sleep 0.2
        done
        echo 100
    ) | whiptail --title "Update do Sistema" --gauge "Atualizando..." 10 70 0

    wait "$pid"
    whiptail --title "Concluído" --msgbox "Update finalizado com sucesso!" 8 60
}

# =============================
#   OPÇÃO 2 - INSTALAR PACOTES
# =============================
install_packages() {
    detect_pkg_manager
    
    if [ -z "$PKG_MGR" ]; then
        whiptail --title "Erro" --msgbox "Nenhum gerenciador (dnf/yum) encontrado!" 8 60
        return 1
    fi

    sudo -v || { 
        whiptail --title "Erro" --msgbox "Preciso de sudo para instalar pacotes." 8 60
        return 1
    }

    CHECKPACKAGES=(lsb_release hyperv-daemons bc epel-release vim-enhanced yum-utils iotop rsync htop screen curl wget ntsysv samba acpid net-tools xinetd mtools speedtest-cli zip mlocate ncdu tar bind-utils dnsutils)

    TOTAL=${#CHECKPACKAGES[@]}

    (
        installed=0
        for pkg in "${CHECKPACKAGES[@]}"; do
            installed=$((installed + 1))
            percent=$(( installed * 100 / TOTAL ))
            echo "$percent"
            if [ "$PKG_MGR" = "dnf" ]; then
                sudo dnf -y install "$pkg" >/dev/null 2>&1
            else
                sudo yum -y install "$pkg" >/dev/null 2>&1
            fi
        done
        echo 100
    ) | whiptail --title "Instalação de Pacotes" --gauge "Instalando..." 10 70 0

    whiptail --title "Concluído" --msgbox "Pacotes básicos instalados!" 8 60
}

# =============================
# OPÇÃO 3 - INSTALAR TELA HARDTEC
# =============================
install_tela_hardtec() {
    sudo -v || { 
        whiptail --title "Erro" --msgbox "Preciso de sudo para configurar." 8 60
        return 1
    }

    (
        echo 10
        mkdir -p /scripts >/dev/null 2>&1
        
        echo 30
        # screenfetch
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL "https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenfetch.sh" \
                -o /usr/bin/screenfetch
        else
            # fallback para wget se curl não existir
            wget -q "https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenfetch.sh" \
                -O /usr/bin/screenfetch
        fi
        chmod +x /usr/bin/screenfetch
        
        echo 60
        # screenshowht.sh
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL "https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenshowht.sh" \
                -o /scripts/screenshowht.sh
        else
            wget -q "https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenshowht.sh" \
                -O /scripts/screenshowht.sh
        fi
        chmod +x /scripts/screenshowht.sh
        
        echo 90
        if ! grep -Fxq '[ -z "$PS1" ]  || /scripts/screenshowht.sh' /etc/profile; then
            echo '[ -z "$PS1" ]  || /scripts/screenshowht.sh' >> /etc/profile
        fi
        
        echo 100
    ) | whiptail --title "Tela Hardtec" --gauge "Instalando..." 10 70 0

    whiptail --title "Concluído" --msgbox "Tela Inicial Hardtec instalada!" 8 60
}

# =============================
# OPÇÃO 4 - INSTALAR TELA PADRÃO
# =============================
install_tela_padrao() {
    sudo -v || { 
        whiptail --title "Erro" --msgbox "Preciso de sudo para configurar." 8 60
        return 1
    }

    (
        echo 10
        mkdir -p /scripts >/dev/null 2>&1
        
        echo 30
        # screenfetch
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL "https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenfetch.sh" \
                -o /usr/bin/screenfetch
        else
            wget -q "https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenfetch.sh" \
                -O /usr/bin/screenfetch
        fi
        chmod +x /usr/bin/screenfetch
        
        echo 60
        # screenshow.sh
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL "https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenshow.sh" \
                -o /scripts/screenshow.sh
        else
            wget -q "https://raw.githubusercontent.com/Crusher131/Hardtec-Newserv/main/screenshow.sh" \
                -O /scripts/screenshow.sh
        fi
        chmod +x /scripts/screenshow.sh
        
        echo 90
        if ! grep -Fxq '[ -z "$PS1" ]  || /scripts/screenshow.sh' /etc/profile; then
            echo '[ -z "$PS1" ]  || /scripts/screenshow.sh' >> /etc/profile
        fi
        
        echo 100
    ) | whiptail --title "Tela Padrão" --gauge "Instalando..." 10 70 0

    whiptail --title "Concluído" --msgbox "Tela Inicial Padrão instalada!" 8 60
}
# =============================
# OPÇÃO 5 - INSTALAR CHRONY
# =============================
install_chrony() {
    detect_pkg_manager
    
    if [ -z "$PKG_MGR" ]; then
        whiptail --title "Erro" --msgbox "Nenhum gerenciador (dnf/yum) encontrado!" 8 60
        return 1
    fi

    sudo -v || { 
        whiptail --title "Erro" --msgbox "Preciso de sudo para instalar Chrony." 8 60
        return 1
    }

    (
        echo 10
        CHRONY_OK=$(rpm -qa | grep "chrony")
        if [ -z "$CHRONY_OK" ]; then
            echo 20
            if [ "$PKG_MGR" = "dnf" ]; then
                sudo dnf install chrony -y >/dev/null 2>&1
            else
                sudo yum install chrony -y >/dev/null 2>&1
            fi
        fi
        
        echo 40
        sudo sed -i 's/^[^#]*server*/#&/' /etc/chrony.conf
        
        echo 60
        if ! grep -q "#Servidores Adicionados HTCHAT" /etc/chrony.conf; then
            echo "#Servidores Adicionados HTCHAT" | sudo tee -a /etc/chrony.conf >/dev/null
        fi
        
        ntp_servers=(
            "server a.st1.ntp.br iburst"
            "server b.st1.ntp.br iburst"
            "server c.st1.ntp.br iburst"
            "server d.st1.ntp.br iburst"
            "server gps.ntp.br iburst"
        )
        
        for i in "${ntp_servers[@]}"; do
            if ! grep -Fxq "$i" /etc/chrony.conf; then
                echo "$i" | sudo tee -a /etc/chrony.conf >/dev/null
            fi
        done
        
        echo 80
        sudo systemctl start chronyd >/dev/null 2>&1
        
        echo 90
        sudo systemctl enable chronyd >/dev/null 2>&1
        
        echo 100
    ) | whiptail --title "Instalação do Chrony" --gauge "Configurando..." 10 70 0

    whiptail --title "Concluído" --msgbox "Chrony instalado e configurado!" 8 60
}

# =============================
# OPÇÃO 6 - DESABILITAR SELINUX
# =============================
disable_selinux() {
    sudo -v || { 
        whiptail --title "Erro" --msgbox "Preciso de sudo para desabilitar SELinux." 8 60
        return 1
    }

    (
        echo 20
        echo 40
        sudo setenforce 0 >/dev/null 2>&1
        
        echo 70
        if ! grep -Fxq "SELINUX=disabled" /etc/selinux/config; then
            sudo sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
        fi
        
        echo 100
    ) | whiptail --title "Desabilitar SELinux" --gauge "Desabilitando..." 10 70 0

    whiptail --title "Concluído" --msgbox "SELinux desabilitado!\n\nRequer reiniciar para aplicar completamente." 10 60
}

# =============================
# OPÇÃO 7 - NOMENCLATURA LEGADA DE REDE (SOBREVIVE SSH + REBOOT AUTO)
# =============================
configure_legacy_network() {
    sudo -v || return 1

    # Script que será executado pelo systemd (sobrevive a queda do SSH)
    sudo tee /usr/local/sbin/hardtec-legacy-net.sh >/dev/null <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# 1) Força nomes legados via kernel cmdline (BLS/Alma9: grubby é o mais confiável)
if command -v grubby >/dev/null 2>&1; then
  grubby --update-kernel=ALL --remove-args="net.ifnames=1 biosdevname=1" >/dev/null 2>&1 || true
  grubby --update-kernel=ALL --args="net.ifnames=0 biosdevname=0" >/dev/null
fi

# (extra) também mantém /etc/default/grub coerente (não é o principal no Alma9, mas ajuda)
if [ -f /etc/default/grub ]; then
  sed -i '/GRUB_CMDLINE_LINUX=/s/net\.ifnames=[0-9]//g' /etc/default/grub
  sed -i '/GRUB_CMDLINE_LINUX=/s/biosdevname=[0-9]//g' /etc/default/grub
  sed -i '/GRUB_CMDLINE_LINUX=/ s/"$/ net.ifnames=0 biosdevname=0"/' /etc/default/grub
  sed -i 's/  */ /g' /etc/default/grub
fi

# 2) "Mata" regra do udev/systemd que aplica nomes previsíveis
ln -sf /dev/null /etc/udev/rules.d/80-net-setup-link.rules
rm -f /etc/udev/rules.d/70-persistent-net.rules || true

# 3) Prepara conexões do NetworkManager sem derrubar o SSH AGORA:
#    - clona as conexões atuais por placa -> cria perfis eth0/eth1...
#    - NÃO derruba a conexão atual; só deixa pronto para o próximo boot
if command -v nmcli >/dev/null 2>&1; then
  mapfile -t devs < <(nmcli -t -f DEVICE,TYPE dev status | awk -F: '$2=="ethernet"{print $1}')
  idx=0
  for dev in "${devs[@]}"; do
    con="$(nmcli -t -f GENERAL.CONNECTION dev show "$dev" | cut -d: -f2 || true)"
    new="eth${idx}"

    # Remove perfil ethX antigo se existir (evita duplicidade)
    nmcli -t -f NAME con show | grep -Fxq "$new" && nmcli con delete "$new" >/dev/null 2>&1 || true

    if [ -n "${con:-}" ] && [ "$con" != "--" ]; then
      nmcli con clone "$con" "$new" >/dev/null 2>&1 || true
      nmcli con modify "$new" connection.interface-name "$new" connection.autoconnect yes connection.autoconnect-priority 100 >/dev/null 2>&1 || true
    else
      nmcli con add type ethernet con-name "$new" ifname "$new" ipv4.method auto ipv6.method ignore connection.autoconnect yes connection.autoconnect-priority 100 >/dev/null 2>&1 || true
    fi

    idx=$((idx+1))
  done
fi

# 4) ESSENCIAL no AlmaLinux 9: recriar initramfs para aplicar regras cedo no boot
dracut -f >/dev/null 2>&1 || dracut -f

sync

# 5) Reinicia automaticamente no final
systemctl reboot
EOF

    sudo chmod +x /usr/local/sbin/hardtec-legacy-net.sh

    # Unit systemd (oneshot)
    sudo tee /etc/systemd/system/hardtec-legacy-net.service >/dev/null <<'EOF'
[Unit]
Description=Hardtec - Apply legacy network naming (eth0, eth1...) and reboot
Wants=network-pre.target
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/hardtec-legacy-net.sh
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload

    # Dispara e pronto (não depende da sua sessão SSH)
    sudo systemctl start hardtec-legacy-net.service &

    # Opcional: só uma mensagem (não pede confirmação)
    whiptail --title "Rede Legada" --msgbox \
"Opção 7 agendada via systemd.\n\nO servidor vai REINICIAR automaticamente ao finalizar.\n\nVocê vai perder a conexão SSH em alguns segundos." 12 70

    # Não adianta continuar o script, porque o reboot vai acontecer
    exit 0
}

# =============================
# OPÇÃO 8 - REINICIAR
# =============================
do_reboot() {
    if whiptail --title "Reiniciar Sistema" --yesno "Deseja realmente reiniciar agora?" 8 60; then
        whiptail --title "Reiniciando" --infobox "Reiniciando em 3 segundos..." 8 60
        sleep 3
        sudo reboot
    fi
}

# =============================
#            MAIN
# =============================

if ! command -v whiptail >/dev/null 2>&1; then
    echo "ERRO: whiptail não está instalado."
    exit 1
fi

while true; do
    SELECTED=$(whiptail --title "Script de Configuração Hardtec" \
        --checklist "Selecione as opções desejadas (ESPAÇO para marcar):" 24 78 8 \
        "1" "Update do sistema" OFF \
        "2" "Instalar pacotes básicos" OFF \
        "3" "Instalar Tela Inicial Hardtec" OFF \
        "4" "Instalar Tela Inicial Padrão" OFF \
        "5" "Instalar Chrony (Gerenciador de horário)" OFF \
        "6" "Desabilitar SELinux" OFF \
        "7" "Configurar nomenclatura legada de rede (eth0, eth1...)" OFF \
        "8" "Reiniciar" OFF \
        3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        exit 0
    fi

    SELECTIONS=$(echo "$SELECTED" | tr -d '"')

    # Validação: só uma tela (3 ou 4)
    tela_count=0
    echo "$SELECTIONS" | grep -qw 3 && tela_count=$((tela_count+1))
    echo "$SELECTIONS" | grep -qw 4 && tela_count=$((tela_count+1))

    if [ $tela_count -gt 1 ]; then
        whiptail --title "Atenção" --msgbox "Selecione apenas UMA tela (Hardtec OU Padrão)." 8 60
        continue
    fi

    break
done

# Executa as opções, mas deixa a 7 por último (porque ela reinicia automaticamente)
ordered=""
has7=0
for c in $SELECTIONS; do
  if [ "$c" = "7" ]; then
    has7=1
  else
    ordered="$ordered $c"
  fi
done
[ "$has7" -eq 1 ] && ordered="$ordered 7"

for choice in $ordered; do
    case $choice in
        1) do_update ;;
        2) install_packages ;;
        3) install_tela_hardtec ;;
        4) install_tela_padrao ;;
        5) install_chrony ;;
        6) disable_selinux ;;
        7) configure_legacy_network ;;  # Agenda via systemd + reboot automático
        8) do_reboot ;;
    esac
done

whiptail --title "Finalizado" --msgbox "Todas as tarefas foram concluídas!" 8 50
