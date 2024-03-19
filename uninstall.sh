if echo "$OSTYPE" | grep -qE '^linux-android.*'; then
    cd $PREFIX
    sudo=""
else
    cd /usr
    sudo="sudo"
fi

$sudo rm -rf ~/.beer bin/beer share/beer-assets

echo "Программа удалена!"