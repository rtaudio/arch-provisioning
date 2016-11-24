
[[ -f pthread-gperftools-hook.so ]] || ( \
	wget -nc https://storage.googleapis.com/google-code-attachments/gperftools/issue-705/comment-0/pthread-gperftools-hook.c && \
	gcc -O -fpic -shared -o pthread-gperftools-hook.so pthread-gperftools-hook.c \
)

rm -f /tmp/jack2_prof.out
CPUPROFILE=/tmp/jack2_prof.out \
CPUPROFILE_FREQUENCY=5000 \
CPUPROFILE_REALTIME=1 \
LD_PRELOAD=../jack2-rtaudio/pthread-gperftools-hook.so:/usr/lib/libprofiler.so \
/usr/bin/jackd -R -S -ddummy -C2 -P2 -r48000 -p48

pprof --pdf "/usr/bin/jackd" /tmp/jack2_prof.out > /tmp/jack2_prof.pdf
pprof --text "/usr/bin/jackd" /tmp/jack2_prof.out > /tmp/jack2_prof.txt

/usr/local/bin/pprof --callgrind /usr/bin/jackd /tmp/jack2_prof.out

# on the host:
TMP=/tmp/jack2_prof_`date +"%T"`
ssh root@192.168.2.120 "/usr/local/bin/pprof --raw /usr/bin/jackd /tmp/jack2_prof.out > $TMP.raw && cat $TMP.raw" > $TMP.raw && pprof --pdf $TMP.raw > $TMP.pdf && xdg-open $TMP.pdf

ssh root@192.168.2.122 "cat /tmp/jack2_prof.pdf" > /tmp/jack2_prof.pdf && xdg-open /tmp/jack2_prof.pdf

# 
#  && CPUPROFILE=/tmp/jack2_prof.out  /usr/bin/jackd -R -ddummy -C2 -P2 -r48000 -p48 &; sleep 1 && jack_connect system:capture_1 system:playback_1 && jack_connect system:capture_2 system:playback_2 && sleep 30 && killall jackd && 
# on the host: PDFTMP=/tmp/jack2_prof_`date +"%T"`.pdf; ssh root@192.168.2.122 "cat /tmp/jack2_prof.pdf" > $PDFTMP && xdg-open $PDFTMP

#Jack
Jack
JackEngineControl JackGraphManager
Ca c l CPULoad GetClientTiming


#cachegrind:
sudo apt-get install valgrind kcachegrind graphviz


TMP=/tmp/jack2_prof_`date +"%T"`; ssh root@192.168.2.120 "/usr/local/bin/pprof --callgrind /usr/bin/jackd /tmp/jack2_prof.out > $TMP.callgrind && cat $TMP.callgrind" > $TMP.callgrind && kcachegrind $TMP.callgrind




CPUPROFILE=/tmp/jack2_prof.out CPUPROFILE_FREQUENCY=10000 LD_PRELOAD=./pthread-gperftools-hook.so:/usr/local/lib/libprofiler.so /usr/bin/jackd -R -ddummy -C2 -P2 -r48000 -p48
