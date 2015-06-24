FROM ubuntu:14.04.2
MAINTAINER Doro Wu <fcwu.tw@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends aptitude \
    && aptitude install -y python-pip=1.5.4-1 python-dev build-essential \
    && apt-get install -y --force-yes -f --no-install-recommends supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        libreoffice firefox \
        fonts-wqy-microhei \
        language-pack-zh-hant language-pack-gnome-zh-hant firefox-locale-zh-hant libreoffice-l10n-zh-tw \
        nginx \
        curl gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine pinta \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN curl -k -O https://dl.dropboxusercontent.com/u/23905041/x11vnc_0.9.14-1.1ubuntu1_amd64.deb \
    && curl -k -O https://dl.dropboxusercontent.com/u/23905041/x11vnc-data_0.9.14-1.1ubuntu1_all.deb \
    && curl -Lk -O "http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_15.04/all/arc-theme_1434267109.2095edb_all.deb" \
    && dpkg -i *.deb && rm *.deb

ADD web /web/
RUN pip install -r /web/requirements.txt

ADD noVNC /noVNC/
ADD nginx.conf /etc/nginx/sites-enabled/default
ADD startup.sh /
ADD supervisord.conf /etc/supervisor/conf.d/
ADD gtkrc-2.0 /root/.gtkrc-2.0

EXPOSE 6080
WORKDIR /root
ENTRYPOINT ["/startup.sh"]
