#!/bin/bash

if [[ -n "$HTPASSWD" ]]
  then
    cp auth.conf /etc/nginx/conf.d/default.conf
    envsubst < auth.htpasswd > /etc/nginx/auth.htpasswd
fi

if [[ ! -f /config/sigal.conf.py ]] ; then 
sed -E 's@#? *source = .*$@source = "/pictures"@' \
          "$(find /usr -name sigal.conf.py)"  | \
          sed -E 's@#? *destination = .*$@destination = "/usr/share/nginx/html"@'| \
          sed -E 's@#? *keep_orig = .*$@keep_orig = True@' | \
          sed -E 's@#? *zip_gallery = .*$@zip_gallery = "archive.zip"@' | \
          sed -E 's@#? *orig_link = .*$@orig_link = True@' | \
          sed -E 's@quality: *[0-9]+ *,$@quality: '$JPEG_QUALITY',@'  \
          > /config/sigal.conf.py
fi
 
build_sigal

if [[ -n "$CRONJOB" ]]
  then
    ( echo "${CRONJOB} root /usr/local/bin/build_sigal 2>&1 > /dev/null" > /etc/cron.d/sigal \
      && echo "Create sigal build crontab" ) 2>&1 | /usr/bin/ts '%Y/%m/%d %H:%M:%S [cronjob]:'

    service cron start 2>&1 | /usr/bin/ts '%Y/%m/%d %H:%M:%S [cronjob]:'
fi

exec nginx -g "daemon off;"

