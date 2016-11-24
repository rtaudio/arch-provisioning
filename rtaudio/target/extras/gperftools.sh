pacman -Sy git autoconf automake gcc make --noconfirm
git clone https://github.com/gperftools/gperftools
cd gperftools/
./autogen.sh
./configure --with-tcmalloc-pagesize=32 --prefix=/usr
make -j6
make install

