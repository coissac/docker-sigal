FROM nginx:stable

WORKDIR /opt

RUN apt-get update && apt-get install -y \
    python3-pip \
    git \
    ffmpeg \
    cron \
    moreutils \
    bsdextrautils \
    htop \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install 'sigal @ git+https://github.com/saimn/sigal.git'

RUN mkdir -p /themes
RUN mkdir -p /config
RUN mkdir -p /plugins/local_plugins
RUN touch /plugins/local_plugins/__init__.py

COPY run.sh auth.conf auth.htpasswd ./

ENV JPEG_QUALITY=90
ENV LANG=C.UTF-8
ENV PYTHONPATH="/themes:/plugins:/config"

COPY build_sigal.sh /usr/local/bin/build_sigal
RUN chmod +x /usr/local/bin/build_sigal

CMD ["./run.sh"]

