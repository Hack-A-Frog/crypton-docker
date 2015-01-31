
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
run wget http://download.redis.io/releases/redis-2.8.8.tar.gz
run tar xzf redis-2.8.8.tar.gz
run rm redis-2.8.8.tar.gz
run cd redis-2.8.8 && make && make install

run cp /redis-2.8.8/utils/redis_init_script /etc/init.d/redis_6379
run mkdir -p /var/redis/6379
run sed -i 's/daemonize no/daemonize yes/' /redis-2.8.8/redis.conf
run sed -i 's/pidfile \/var\/run\/redis.pid/pidfile \/var\/run\/redis_6379.pid/' /redis-2.8.8/redis.conf
run sed -i 's/logfile ""/logfile \/var\/log\/redis_6379.log/' /redis-2.8.8/redis.conf
run mkdir -p /etc/redis
run cp /redis-2.8.8/redis.conf /etc/redis/6379.conf
run update-rc.d redis_6379 defaults

# install node
run apt-get install -y nodejs npm
run ln -s /usr/bin/nodejs /usr/bin/node

# install postgres
run apt-get install -y postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3
run service postgresql restart
run sudo -u postgres psql postgres

# phantomjs dependencies
run apt-get install -y bzip2 curl libfreetype6 libfontconfig1

#user postgres
run echo "host all  all    0.0.0.0/0  trust" >> /etc/postgresql/9.3/main/pg_hba.conf
run echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf
run echo "local   all             all                                     trust" >> /etc/postgresql/9.3/main/pg_hba.conf
run echo "host    all             all             127.0.0.1/32            trust" >> /etc/postgresql/9.3/main/pg_hba.conf
run echo "host    all             all             ::1/128            trust" >> /etc/postgresql/9.3/main/pg_hba.conf

# get crypton
run git clone https://github.com/SpiderOak/crypton.git

run npm config set registry http://registry.npmjs.org/

# link crypton server
run cd crypton/server && npm link

run cd /crypton && make

# expose only the crypton port
expose 443
expose 1025
