vagrant up
vagrant ssh
cd /vagrant

docker build -rm -t shamrin/osmonitb .

docker run -i -t shamrin/osmonitb /bin/bash

docker run -p 3002:3002 -p 3003:3003 shamrin/osmonitb osmo-nitb -c /root/open-bsc.cfg -l /root/hlr.sqlite3 -P -C --debug=DRLL:DCC:DMM:DRR:DRSL:DNM
