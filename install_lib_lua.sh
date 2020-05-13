#!/bin/bash

wget https://www.lua.org/ftp/lua-5.3.5.tar.gz
tar -xzvf lua-5.3.5.tar.gz
sudo cp -r lua-5.3.5/src/* /usr/include
git clone https://github.com/stetre/moonfltk.git
cd moonfltk
make
sudo make install
cd ..
rm -r lua-5.3.5 moonfltk
echo "Todos componentes instalados!"
