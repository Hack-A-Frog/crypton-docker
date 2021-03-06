
from ubuntu:14.04
maintainer Derek Smith <derek@goldenfrog.com>

# housekeeping
run apt-get update -y
run DEBIAN_FRONTEND=noninteractive apt-get -y install language-pack-en

env LANGUAGE en_US.UTF-8
env LANG en_US.UTF-8
env LC_ALL en_US.UTF-8
env DEBIAN_FRONTEND noninteractive

run locale-gen en_US.UTF-8
run dpkg-reconfigure locales
run update-locale LANG=en_US.UTF-8

# install apt-utils
run apt-get install -y apt-utils

# compilation dependencies
run apt-get install -y git wget make gcc g++

# install redis
run \
  wget http://download.redis.io/releases/redis-2.8.8.tar.gz; \
  tar xzf redis-2.8.8.tar.gz; \
  rm redis-2.8.8.tar.gz; \
  cd redis-2.8.8 && make && make install;

# Don't let redis start in the background
run \
  cp /redis-2.8.8/utils/redis_init_script /etc/init.d/redis_6379; \
  mkdir -p /var/redis/6379;
run \
	sed -i 's/pidfile \/var\/run\/redis.pid/pidfile \/var\/run\/redis_6379.pid/' /redis-2.8.8/redis.conf; \
  sed -i 's/logfile ""/logfile \/var\/log\/redis_6379.log/' /redis-2.8.8/redis.conf;
run \
  mkdir -p /etc/redis; \
  cp /redis-2.8.8/redis.conf /etc/redis/6379.conf;
run update-rc.d redis_6379 defaults

# install node
run apt-get install -y nodejs npm
run ln -s /usr/bin/nodejs /usr/bin/node

# install postgres
run apt-get install -y postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3
run \
  service postgresql restart; \
  sudo -u postgres psql postgres;

# phantomjs dependencies
run apt-get install -y bzip2 curl libfreetype6 libfontconfig1

#user postgres
run echo "listen_addresses='*'"                                                        >> /etc/postgresql/9.3/main/postgresql.conf
run \
  echo "host    all             all             0.0.0.0/0          trust" >> /etc/postgresql/9.3/main/pg_hba.conf; \
  echo "local   all             all                                trust" >> /etc/postgresql/9.3/main/pg_hba.conf; \
  echo "host    all             all             127.0.0.1/32       trust" >> /etc/postgresql/9.3/main/pg_hba.conf; \
  echo "host    all             all             ::1/128            trust" >> /etc/postgresql/9.3/main/pg_hba.conf

# get crypton
run git clone https://github.com/SpiderOak/crypton.git

run npm config set registry http://registry.npmjs.org/

# link crypton server
run cd crypton/server && npm link

run \
  (service redis_6379 start &); \
  service postgresql restart; \
  cd /crypton && make;

run apt-get install -y openssh-server supervisor
copy supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
copy supervisord/postgresql.sh /etc/supervisor/postgresql.sh
run chmod 755 /etc/supervisor/postgresql.sh

run mkdir -p /var/run/sshd /var/log/supervisor

# expose only the crypton port
expose 443
expose 1025
