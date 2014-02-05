from ubuntu:precise

run DEBIAN_FRONTEND=noninteractive apt-get update -q -y
run DEBIAN_FRONTEND=noninteractive apt-get -q -y install curl gcc
run DEBIAN_FRONTEND=noninteractive apt-get -q -y install make git
run DEBIAN_FRONTEND=noninteractive apt-get -q -y install autoconf libtool pkg-config

# oRTP, https://openbsc.osmocom.org/trac/wiki/network_from_scratch#oRTP
run curl -O -L http://download.savannah.gnu.org/releases/linphone/ortp/sources/ortp-0.22.0.tar.gz \
    && tar xvzf ortp-0.22.0.tar.gz \
    && cd ortp-0.22.0 \
    && ./configure && make && make install \
    && ldconfig \
    && cd ..

# libosmocore, https://openbsc.osmocom.org/trac/wiki/network_from_scratch#libosmocore
run git clone git://git.osmocom.org/libosmocore.git \
    && cd libosmocore \
    && autoreconf -i \
    && ./configure && make && make install \
    && ldconfig \
    && cd ..

# libosmo-abis, https://openbsc.osmocom.org/trac/wiki/network_from_scratch#libosmo-abis
run git clone git://git.osmocom.org/libosmo-abis.git \
    && cd libosmo-abis \
    && git checkout -b jolly/multi-trx origin/jolly/multi-trx \
    && autoreconf -i \
    && ./configure && make && make install \
    && ldconfig \
    && cd ..

run DEBIAN_FRONTEND=noninteractive apt-get -q -y install libdbd-sqlite3 libdbi0-dev

# OsmoNITB, https://openbsc.osmocom.org/trac/wiki/network_from_scratch#OsmoNITB
run git clone git://git.osmocom.org/openbsc.git \
    && cd openbsc/openbsc/ \
    && git checkout -b jolly/testing origin/jolly/testing \
    && autoreconf -i \
    && ./configure && make && make install \
    && cd ../..

add open-bsc.cfg /open-bsc.cfg
