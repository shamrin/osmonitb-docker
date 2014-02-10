## Building
vagrant up
vagrant ssh
cd /vagrant
docker build -rm -t shamrin/osmonitb .

## Running and entering Linux VM
vagrant halt
env FORWARD_PORTS=3002,3003 FORWARD_UDP_PORTS=30000,30001,30002,30003,30004,30005,30006,30007,30008 vagrant up --no-provision
vagrant ssh

## Running under bash
docker run -i -t -p 3002:3002 -p 3003:3003 shamrin/osmonitb /bin/bash
osmo-nitb -c /root/open-bsc.cfg -l /root/hlr.sqlite3 -P -C --debug=DRLL:DCC:DMM:DRR:DRSL:DNM &
lsof -i
telnet localhost 4242

## Running directly
docker run -d -p 3002:3002 -p 3003:3003 shamrin/osmonitb osmo-nitb -c /root/open-bsc.cfg -l /root/hlr.sqlite3 -P -C --debug=DRLL:DCC:DMM:DRR:DRSL:DNM
docker logs -f ...
sudo lxc-attach -n ...

