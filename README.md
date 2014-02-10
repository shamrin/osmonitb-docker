## OpenBSC, containerized

Docker container for [OpenBSC][0], **the** open source implementation of GSM [Base Station Controller][1], which - together with [BTS][2] - makes up a functional GSM "cell". Here's the configuration tested:

```
 +----------------------------------------+
 | MacBook                                |
 |                                        |
 |  +-------------------------------+     |
 |  | VirtualBox VM                 |     |
 |  |                               |     |
 |  |  +----------------------+     |     |             |
 |  |  | Docker container     |     |     |         \   |   /       |
 |  |  | (Ubuntu 12.04)       |     |     |          \  |  /        |
 |  |  |                      |     |     |           \ | /         |
 |  |  |  +-------------+     |     |     |        +----+----+     +-------+
 |  |  |  | OpenBSC     |     |     |     |        |         |     | GSM   |
 |  |  |  | (osmo-nitb) |<-------------------------+   BTS   |     | phone |
 |  |  |  |             |     |     |     |        |         |     |       |
 |  |  |  +-------------+     |     |     |        |         |     |       |
 |  |  |                      |     |     |        |         |     |       |
 |  |  +----------------------+     |     |        +---------+     +-------+
 |  |                               |     |
 |  +-------------------------------+     |
 |                                        |
 +----------------------------------------+
```

BTS was comprised of [Fairwaves][5] UmSITE hardware and [OsmoBTS][3] software.

**Note:** OpenBSC runs perfectly fine inside UmSITE computer, alongside OsmoBTS. But OpenBSC could control *several* BTSes. Addtionaly, the above configuration is convienient during development. 

[0]: http://openbsc.osmocom.org/trac/wiki/OpenBSC
[1]: https://en.wikipedia.org/wiki/Base_station_subsystem#Base_station_controller
[2]: https://en.wikipedia.org/wiki/Base_station_subsystem#Base_transceiver_station
[3]: http://openbsc.osmocom.org/trac/wiki/OsmoBTS
[4]: http://openbsc.osmocom.org/trac/wiki/osmo-nitb
[5]: http://fairwaves.ru/

### Run and enter Vagrant VM

**(skip if running Ubuntu natively)**

    vagrant up
    vagrant ssh
    cd /vagrant

### Build Docker image

    docker build -rm -t shamrin/osmonitb .

### Run networked Vagrant VM

**(skip if running Ubuntu natively)**

Bridged setup is recommended, but make sure you can trust your network (we couldn't make port mapping work, there were problems with RTP voice traffic):

    vagrant halt
    env BRIDGED_NETWORK=yes vagrant up --no-provision
    vagrant ssh

Then check IP address with `ifconfig` inside the VM.

### Run Docker container

    docker run -v $HOME/db:/var/db -i -t -p 3002:3002 -p 3003:3003 -p 30000:30000/udp -p 30001:30001/udp -p 30002:30002/udp -p 30003:30003/udp -p 30004:30004/udp -p 30005:30005/udp -p 30006:30006/udp -p 30007:30007/udp -p 30008:30008/udp 30009:30009/udp 30010:30010/udp 30012:30012/udp 30012:30012/udp shamrin/osmonitb /start OUR_IP

Replace `OUR_IP` with the IP address you found above.

### Configure OsmoBTS

Set `oml remote-ip` in OsmoBTS config to point to OpenBSC IP address (OUR_IP above). E.g.:

   oml remote-ip 10.0.0.10

### Attach to running container

    docker ps --no-trunc # note full container ID
    sudo lxc-attach -n FULL_CONTAINER_ID
    telnet localhost 4242 # OpenBSC VTY
