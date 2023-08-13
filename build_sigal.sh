#!/bin/bash

cd /opt || exit

rm -f ./sigal.conf.py 
if [[ -f /config/sigal.conf.py ]] ; then
   ln -s /config/sigal.conf.py sigal.conf.py 
else
    sigal init
fi

/usr/local/bin/sigal build 2>&1 \
    | col -b \
    | /usr/bin/ts '%Y/%m/%d %H:%M:%S [sigal build]:' \
    | tee /proc/1/fd/1
