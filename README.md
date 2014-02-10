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
docker run -v $HOME/db:/var/db -i -t -p 3002:3002 -p 3003:3003 -p 30000:30000/udp -p 30001:30001/udp -p 30002:30002/udp -p 30003:30003/udp -p 30004:30004/udp -p 30005:30005/udp -p 30006:30006/udp -p 30007:30007/udp -p 30008:30008/udp shamrin/osmonitb /bin/bash
osmo-nitb -c /root/open-bsc.cfg -l /var/db/hlr.sqlite -P -C --debug=DRLL:DCC:DMM:DRR:DRSL:DNM:DMNCC

## Running directly
docker run -d ...
docker logs -f ...

## Attaching to running container
docker ps --no-trunc # note full container ID
sudo lxc-attach -n CONTAINER_ID
telnet localhost 4242
