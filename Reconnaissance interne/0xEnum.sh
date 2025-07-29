#!/bin/bash
_______          ___________                     
\   _  \ ___  ___\_   _____/ ____  __ __  _____  
/  /_\  \\  \/  / |    __)_ /    \|  |  \/     \ 
\  \_/   \>    <  |        \   |  \  |  /  Y Y  \
 \_____  /__/\_ \/_______  /___|  /____/|__|_|  /
       \/      \/        \/     \/            \/ 

exec > >(tee "enum_$(hostname)_$(date +%F_%H-%M).log") 2>&1

read -p " Entrez le mot de passe de l'utilisateur actuel : " PASS

echo ""
echo "========== [ ENUMÉRATION DU SYSTÈME - $(hostname) ] =========="

echo -e "\n--- Vérification des droits sudo ---"
echo "$PASS" | sudo -S -l 
sleep 3

echo -e "\n--- Commandes sudo sans mot de passe ? ---"
grep -r 'NOPASSWD' /etc/sudoers /etc/sudoers.d 2>/dev/null
sleep 3

echo -e "\n--- Contenu de /etc/sudoers (sans commentaires) ---"
echo "$PASS" | sudo -S cat /etc/sudoers 2>/dev/null | grep -v '^#'
sleep 3

echo -e "\n--- Identité et groupe de l'utilisateur ---"
id
groups
sleep 3

echo -e "\n--- Infos système : nom, version, noyau ---"
uname -a
cat /etc/os-release 2>/dev/null
cat /etc/issue 2>/dev/null
sleep 3

echo -e "\n--- Utilisateurs avec un shell valide ---"
getent passwd | grep -Ev '/nologin|/false'
sleep 3

echo -e "\n--- Groupes système présents ---"
getent group
sleep 3

echo -e "\n--- Fichiers SUID ---"
find / -perm -4000 -type f 2>/dev/null
sleep 3

echo -e "\n--- Fichiers GUID ---"
find / -perm -2000 -type f 2>/dev/null
sleep 3

echo -e "\n--- Fichiers world-writable (écriture pour tous) ---"
find / -type f -perm -0002 -exec ls -l {} 2>/dev/null \; | grep -v '/proc'
sleep 3

echo -e "\n--- Répertoires world-writable ---"
find / -type d -perm -0002 -exec ls -ld {} 2>/dev/null \; | grep -v '/proc'
sleep 3

echo -e "\n--- Recherche des fichiers *.db en cours ---"
find / -type f -name "*.db" 2>/dev/null
echo "--- Recherche .db terminée ---"
sleep 3

echo -e "\n--- Ports TCP/UDP ouverts en écoute ---"
ss -tulnp
sleep 3

echo -e "\n--- Processus en cours d'exécution par root ---"
ps -U root -u root u
sleep 3

echo -e "\n--- Tâches cron des utilisateurs ---"
for user in $(cut -f1 -d: /etc/passwd); do
  crontab -u "$user" -l 2>/dev/null
done
sleep 3

echo -e "\n--- Tâches cron système ---"
ls -l /etc/cron* 2>/dev/null
sleep 3

echo -e "\n--- Fichiers d'historique du shell ---"
ls -la ~/.*history 2>/dev/null
sleep 3

echo -e "\n--- Recherche de mots de passe dans fichiers utilisateur ---"
grep -iE 'pass(word)?|pwd' ~/.* 2>/dev/null
sleep 3

echo -e "\n--- Interfaces réseau ---"
ip a
sleep 3

echo -e "\n--- Routes réseau ---"
ip route
sleep 3

echo -e "\n--- DNS configurés ---"
cat /etc/resolv.conf
sleep 3

echo -e "\n--- Adresse IP locale ---"
hostname -I | cut -d" " -f1
sleep 3

echo -e "\n--- Outils installés (présence dans le PATH) ---"
which nc nmap python python3 perl gcc curl wget 2>/dev/null
sleep 3

echo -e "\n--- Présence de conteneur Docker/LXC ? ---"
[ -f "/.dockerenv" ] && echo "Docker détecté"
grep -qa container=lxc /proc/1/environ && echo "LXC détecté"
sleep 3

echo -e "\n--- Services actifs (systemd) ---"
systemctl list-units --type=service --state=running 2>/dev/null
sleep 3

echo -e "\n[✔] Énumération terminée. Rapport sauvegardé dans $(pwd)/enum_$(hostname)_$(date +%F_%H-%M).log"
sleep 2
