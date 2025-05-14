#!/bin/bash

read -p " Entrez le mot de passe de l'utilisateur actuel : " PASS

echo ""
echo "Vérification des droits sudo"
echo "$PASS" | sudo -S -l 
sleep 3
echo ""

echo "Identité de l'utilisateur"
sleep 3
id
sleep 3
echo ""

echo "Recherche des fichiers *.db en cours..."
sleep 3
find / -type f -name "*.db" 2>/dev/null
echo ""
echo "Recherche .db terminée."
sleep 3

echo ""
echo "Ports TCP/UDP ouverts en écoute"
sleep 3
ss -tulnp
sleep 3

echo ""
echo "Terminé"
sleep 2
