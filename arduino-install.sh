#!/bin/sh

VER=$(curl -s -f https://www.arduino.cc/en/main/software | grep -o 'arduino-[0-9.]\+[0-9]-windows.exe' | sed 's/arduino-//' | sed 's/-windows.exe//')
echo "$VER"

if [ ! -f "arduino-${VER}-linux64.tar.xz" ]; then
  rm -rf arduino-*-linux64.tar.xz
  curl https://downloads.arduino.cc/arduino-${VER}-linux64.tar.xz --output "arduino-${VER}-linux64.tar.xz"
fi

sudo mkdir -p /opt
sudo rm -rf /opt/arduino
sudo rm -rf "/opt/arduino-${VER}"
sudo tar -xJvf "arduino-${VER}-linux64.tar.xz" -C /opt
sudo ln -s "/opt/arduino-${VER}" /opt/arduino

id -u arduino &>/dev/null || sudo useradd arduino -m
sudo chown -R arduino:arduino /opt/arduino/
sudo chown -R arduino:arduino "/opt/arduino-${VER}/"

sudo usermod -a -G arduino "$(whoami)"
# sudo usermod -a -G uucp "$(whoami)"
sudo usermod -a -G tty "$(whoami)"
sudo usermod -a -G dialout "$(whoami)"
sudo pacman -S minicom
sudo pacman -S moserial
echo stty -F /dev/ttyUSB0 hupcl
echo stty -F /dev/ttyUSB0 -hupcl
echo stty -a -F /dev/ttyUSB0

# cd "$HOME/projects"
# git clone git@github.com:arduino/arduino-cli.git
# cd arduino-cli
# cd "$HOME"
# curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
if [ ! -f "go1.14.1.linux-amd64.tar.gz" ]; then
  wget 'https://dl.google.com/go/go1.14.1.linux-amd64.tar.gz'
fi
tar xvf go1.14.1.linux-amd64.tar.gz
sudo mv -v go /usr/local

echo "go get -u github.com/arduino/arduino-cli"
go get -u github.com/arduino/arduino-cli

# arduino-cli core search arduino
# arduino-cli core search leonardo
# arduino-cli core search uno
# arduino-cli core search samd

# Arduino board support like Leonardo/Uno
arduino-cli core update-index
arduino-cli core install arduino:avr
# Or if you need SAMD21/SAMD51 support:
# arduino-cli core install arduino:samd
arduino-cli core install esp8266:esp8266

pip install pyserial --user

echo arduino-cli sketch new example-arduino
arduino-cli compile --fqbn arduino:avr:uno example-arduino
arduino-cli compile --fqbn esp8266:esp8266:d1_mini example-arduino
arduino-cli compile --fqbn esp32:esp32:d1_mini32 example-arduino
arduino-cli upload --port /dev/ttyUSB0 --fqbn arduino:avr:uno example-arduino¬

arduino-cli board list

$HOME/.arduino15/packages/esp8266/hardware/esp8266/2.6.3/tools/esptool/esptool.py erase_flash

$HOME/.arduino15/packages/esp32/hardware/esp32/1.0.4/tools/esptool.py erase_flash

$HOME/.arduino15/packages/esp32/hardware/esp32/1.0.4/tools/esptool.py read_mac

exit 0
