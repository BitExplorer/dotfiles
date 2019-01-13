#!/bin/sh

read -p "Enter PASSWD: "  PASSWD
if [ -z "$PASSWD" ]; then
  echo "passwd is empty"
  exit 1
fi

echo $PASSWD

cat > ssmtp.conf << 'EOF'
mailhub=smtp.gmail.com:587
AuthUser=henninb08@gmail.com
AuthPass=password
UseSTARTTLS=YES
EOF

if [ \( "$OS" = "Linux Mint" \) -o \(  "$OS" = "Ubuntu" \) -o \(  "$OS" = "Raspbian GNU/Linux" \) ]; then
  sudo apt install -y ssmtp mailutils net-tools
elif [ "$OS" = "CentOS Linux" ]; then
  echo here
elif [ "$OS" = "Arch Linux" ]; then
  echo here
else
  echo "$OS not implemented"
  exit 1
fi

echo test | mail -s "Test subject $(uname -n)" henninb@gmail.com

netstat -na | grep 25 | grep LISTEN | grep tcp

exit 0
