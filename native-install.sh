# your username
THIS_USERNAME=<USERNAME>
# location for the x11vnc deb
# e.g https://dl.dropboxusercontent.com/u/23905041/ NOTE: keep the last slash(/)
X11VNC_PKGSRV=<PATH-TO-SERVER>

## uncomment if use other source
# mv /etc/apt/sources.list /etc/apt/sources.list.backup
# cp sources-list/ustc-sources.list /etc/apt/sources.list

## install parts
apt-get update \
    && apt-get install -y --force-yes --no-install-recommends supervisor \
               openssh-server pwgen sudo vim-tiny \
               net-tools wget \
               lxde x11vnc xvfb \
               gtk2-engines-murrine ttf-ubuntu-font-family \
               nginx \
               python-pip python-dev build-essential \
               mesa-utils libgl1-mesa-dri \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# install correct vnc server
wget --directory-prefix=/tmp ${X11VNC_PKGSRV}x11vnc_0.9.14-1.1ubuntu1_amd64.deb
wget --directory-prefix=/tmp ${X11VNC_PKGSRV}x11vnc-data_0.9.14-1.1ubuntu1_all.deb
dpkg -i /tmp/x11vnc*

## webserver
cp -r web /web/
pip install -r /web/requirements.txt

## noVNC files
cp -r noVNC /noVNC/

## webserver
cp nginx.conf /etc/nginx/sites-enabled/default

## startup stuff
cp native-startup.sh /startup.sh
### change user name accordingly
sed -i s/ubuntu/${THIS_USERNAME}/g supervisord.conf
cp supervisord.conf /etc/supervisor/conf.d/
