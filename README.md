## SOGo local repository.

There are too many dependencies in SOGo, so it is much easier to create a local file-based
repo and install SOGo with `apt-get` instead of `dpkg` dependency hell.

## Download

You will find latest `SOGo-*_bookworm-amd64.tar.gz` on [Releases](https://github.com/filimonic/sogo-build/releases) page.

## Instructions

Download `SOGo-*_bookworm-amd64.tar.gz`, and integrate it into `apt` system as local file-based trusted repository

```bash
### Install repository as local file repo
rm --force ./SOGo-*_bookworm-amd64.tar.gz
wget https://github.com/filimonic/sogo-build/releases/download/SOGO-5.11.2/SOGo-5.11.2_bookworm-amd64.tar.gz
mkdir --parent /opt/SOGo-repo
rm --recursive --force /opt/SOGo-repo/*
tar --extract --file ./SOGo-5.11.2_bookworm-amd64.tar.gz --directory /opt/SOGo-repo
echo "deb [trusted=yes] file:/opt/SOGo-repo /" > /etc/apt/sources.list.d/sogo-local-repo.list

### Update repo info
apt update

### Install sogo and SQL lib
apt install sogo sope4.9-gdl1-postgresql sope4.9-gdl1-mysql 

### SOGo requires HTTPS for Web UI:
### Enable necessary apache modules, link SOGo.conf to conf-enabled, setup SSL site as default
rm /etc/apache2/sites-enabled/000-default.conf
a2enmod ssl
a2enmod headers
a2enmod proxy_http
a2enmod proxy
ln -s /etc/apache2/conf{.d,-enabled}/SOGo.conf
ln -s /etc/apache2/sites-{available,enabled}/default-ssl.conf

### Proceed with configuration manual

```
