# sigal Docker image

This project is a fork of the [remche/docker-sigal](https://github.com/remche/docker-sigal) project.
The Docker image, based on nginx official one, includes the code for running a [sigal](http://sigal.saimon.org/en/latest/) gallery website.

Default configuration use the galleria theme, keep original and put gallery in /usr/share/nginx/html. You can use a docker volume if you want it permanent
## Exposed volumes

- `/pictures` : Where your data files are stored.
- `/config` : Where you can find and edit the configuration file
- `/themes` : Where you can store external themes
- `/plugins` : Where you can store external plugins
- `/usr/share/nginx/html` : Where the generated HTML code is stored. 
              Decalring it as a volume allows for making it permanent

docker run command setting all these volumes

```bash
mkdir -p pictures config themes plugins html

docker run -p 8888:80 \
    -v ./pictures:/pictures \
    -v ./config:/config \
    -v ./themes:/themes \
    -v ./plugins:/plugins \
    -v ./html:/usr/share/nginx/html \
    -n sigal-server \
    -d zafacs/sigal
```

## Environment variables

- `JPEG_QUALITY`: set the default quality for *JPEG* conversion.
             Option to be added to the docker run command :
- `HTPASSWD`: Allows for setting a basic authentication in `htpasswd`.
              You might then use SSL with 
              [nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/).
- `CRONJOB`: Allows to define a `cron` task in the docker container that will
             update the website. The value of the CRONJOB variable is a text
             constituted of 5 items defining at witch time the update has to be done.
             The syntax follows the [crontab syntax](https://tecadmin.net/crontab-in-linux-with-20-examples-of-cron-schedule/)
    + `* * * * *` : The site is updated every minute.
    + `10 * * * *` : The site is updated every hour at the $10^{th}$ minute.
    + `*/15 * * * *` : The site is updated every 15 minutes.
  

```bash
docker run -p 8888:80 \
    -v ./pictures:/pictures \
    -v ./config:/config \
    -v ./themes:/themes \
    -v ./plugins:/plugins \
    -v ./html:/usr/share/nginx/html \
    -n sigal-server \
    -e JPEG_QUALITY=80 \
    -e HTPASSWD='foo:$apr1$odHl5EJN$KbxMfo86Qdve2FH4owePn.' \
    -e CRONJOB='*/15 * * * *' \
    -d zafacs/sigal
 ```

You can use the following command to force the regeneration of gallery :

```bash
docker exec sigal-ct  build_sigal
```
