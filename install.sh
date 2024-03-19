#!/bin/bash

echo "Начинаем установку..."

is_android=false

sudo="sudo"
update="update"
install="install -y"

if echo "$OSTYPE" | grep -qE '^linux-gnu.*' && [ -f '/etc/debian_version' ]; then
    pkgmgr="apt"

elif echo "$OSTYPE" | grep -qE '^linux-gnu.*' && [ -f '/etc/arch-release' ]; then
    pkgmgr="pacman"
    install="-Sy --noconfirm"
    update="-Sy"

elif echo "$OSTYPE" | grep -qE '^linux-android.*'; then
    pkgmgr="pkg"
    is_android=true

    sudo=""

else
    echo "Платформа не поддерживается."
    exit 1
fi

if ! command -v cowsay &> /dev/null || ! command -v lolcat &> /dev/null ; then
    echo "Установка cowsay и lolcat..."

    $sudo $pkgmgr $update

    if [[ $is_android == true ]]; then
        $pkgmgr $install cowsay ruby wget patch
        patch -p1 $PREFIX/bin/cowsay cowsay.patch
        wget https://github.com/busyloop/lolcat/archive/master.zip
        unzip master.zip && rm master.zip
        cd lolcat-master/bin
        gem install lolcat
        cd ../..

    else
        sudo $pkgmgr $install cowsay lolcat
    fi
fi

echo "Установка..."
if [[ $is_android == true ]]; then
    usr=$PREFIX
else
    usr=/usr
fi

$sudo cp beer $usr/bin
$sudo cp -r beer-assets $usr/share

$sudo mkdir -p ~/.beer
$sudo cp uninstall.sh ~/.beer
$sudo chmod +x ~/.beer/uninstall.sh $usr/bin/beer

echo "Установка завершена!"

beer
