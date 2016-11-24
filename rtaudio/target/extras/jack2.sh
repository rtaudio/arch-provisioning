FLAGS=""
LDFLAGS=""

if ! [[ -z `gcc -v 2>&1 | grep hard` ]]; then FLAGS="$FLAGS -mfloat-abi=hard"; 
else FLAGS="-mfloat-abi=softfp $FLAGS"; fi


#beaglebone black:
FLAGS="$FLAGS -mfpu=neon -mthumb -march=armv7-a -mtune=cortex-a8"


# Profile jack with gperftools (requires ghostscript graphviz)
#LDFLAGS="-lprofiler" # link to gperftools
# then start jack:
# CPUPROFILE=/tmp/jack2_prof.out /usr/bin/jackd -R -ddummy -C2 -P2 -r48000 -p48
# rm -f /tmp/jack2_prof.out && CPUPROFILE=/tmp/jack2_prof.out LD_PRELOAD=/usr/lib/libprofiler.so /usr/bin/jackd -R -ddummy -C2 -P2 -r48000 -p48 &; sleep 1 && jack_connect system:capture_1 system:playback_1 && jack_connect system:capture_2 system:playback_2 && sleep 30 && killall jackd && pprof --pdf "/usr/bin/jackd" /tmp/jack2_prof.out > /tmp/jack2_prof.pdf
# on the host: ssh root@192.168.2.122 "cat /tmp/jack2_prof.pdf" > /tmp/jack2_prof.pdf && xdg-open /tmp/jack2_prof.pdf

pacman -Sy git python pkg-config gcc make alsa-lib alsa-utils --noconfirm
git clone https://github.com/jackaudio/jack2.git
cd jack2/
chmod +x waf svnversion_regenerate.sh
killall jackd
CFLAGS=$FLAGS CXXFLAGS=$FLAGS LINKFLAGS=$LDFLAGS ./waf configure --alsa --portaudio=no --prefix=/usr
./waf -j6 && ./waf install


# jack should run in Sync mode!!!
# sem_timedwait can return Interrupted system Call EINTR
