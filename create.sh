#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color (zum Zurücksetzen)

if [ -z "$1" ]; then
  echo -e "${RED}Bitte einen Name angeben!${NC}"
  echo -e "${RED}Verwendung: $0 <Name> [Startskriptname]${NC}"
  exit 1
fi

NAME=$1
START_SCRIPT=${2:-start.sh} # Standardmäßig start.sh
BOT_USER="discordbot_$NAME"

if id "$BOT_USER" &>/dev/null; then
  echo -e "${RED}Der Benutzer '$BOT_USER' existiert bereits.${NC}"
else
  sudo useradd -m -s /bin/bash "$BOT_USER"
  echo -e "${GREEN}Der Benutzer '$BOT_USER' wurde erstellt.${NC}"
fi

sudo -u "$BOT_USER" mkdir -p "/home/$BOT_USER"
echo -e "${GREEN}Der Ordner '/home/$BOT_USER' wurde erstellt.${NC}"

START_SCRIPT_PATH="/home/$BOT_USER/$START_SCRIPT"
sudo -u "$BOT_USER" bash -c "cat <<EOL > $START_SCRIPT_PATH
#!/bin/bash

pm2 start bot.js --name \"$BOT_USER\"
EOL"

sudo -u "$BOT_USER" chmod +x "$START_SCRIPT_PATH"
echo -e "${GREEN}Das Startskript '$START_SCRIPT_PATH' wurde erstellt und ausführbar gemacht.${NC}"

echo -e "${GREEN}Der Benutzer '$BOT_USER' hat Zugriff auf den Ordner und die Startskripte.${NC}"

echo -e "${YELLOW}Wechsle zum Benutzer '$BOT_USER', um den Bot zu verwalten:${NC}"
echo -e "${YELLOW}sudo su - $BOT_USER${NC}"
echo -e "${YELLOW}Füge den Bot-Code in die Datei '/home/$BOT_USER/bot.js' ein.${NC}"
echo -e "${YELLOW}Starte den Bot mit:${NC}"
echo -e "${YELLOW}cd /home/$BOT_USER && ./start.sh${NC}"
