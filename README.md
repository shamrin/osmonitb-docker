## OpenBSC, containerized
## osmonitb-docker - OpenBSC NITB Docker container

`osmonitb-docker` is a Docker container for [OpenBSC][0] in [osmo-nitb][4] mode. OpenBSC is **the** implementation of GSM [Base Station Controller][1]. Here's the configuration tested:

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

[BTS][2] was comprised of [Fairwaves][5] UmSITE hardware and [OsmoBTS][3] software.

**Note:** OpenBSC runs perfectly fine inside UmSITE computer, alongside OsmoBTS. But OpenBSC could control *several* BTSes. Additionally, the above configuration is convenient during development. 

[0]: http://openbsc.osmocom.org/trac/wiki/OpenBSC
[1]: https://en.wikipedia.org/wiki/Base_station_subsystem#Base_station_controller
[2]: https://en.wikipedia.org/wiki/Base_station_subsystem#Base_transceiver_station
[3]: http://openbsc.osmocom.org/trac/wiki/OsmoBTS
[4]: http://openbsc.osmocom.org/trac/wiki/osmo-nitb
[5]: http://fairwaves.ru/

### Run and enter Vagrant VM

*(skip if running Ubuntu natively)*

    vagrant up
    vagrant ssh
    cd /vagrant

### Build Docker image

    docker build -rm -t shamrin/osmonitb .

### Run networked Vagrant VM

*(skip if running Ubuntu natively)*

VM directly connects to the same networkg as your host, so make sure you can trust your network:

    exit
    vagrant halt
    env BRIDGED_NETWORK=yes vagrant up --no-provision
    vagrant ssh

Then check Docker host IP address with `ifconfig` inside the VM.

### Run Docker container

    docker run -v $HOME/db:/var/db -i -t -p 3002:3002 -p 3003:3003 -p 30000:30000/udp -p 30001:30001/udp -p 30002:30002/udp -p 30003:30003/udp -p 30004:30004/udp -p 30005:30005/udp -p 30006:30006/udp -p 30007:30007/udp -p 30008:30008/udp 30009:30009/udp 30010:30010/udp 30011:30011/udp 30012:30012/udp shamrin/osmonitb /start 10.0.0.10

Replace `10.0.0.10` with the IP address of Docker host.

**Note:** Docker [doesn't yet allow a range of ports][6] to be opened, that's why (RTP) ports has to be all specified one by one. Add ports to support more calls.

[6]: https://github.com/dotcloud/docker/issues/1834

### Configure OsmoBTS

Set `oml remote-ip` in OsmoBTS config to point to OpenBSC IP address (the same as above) and make sure OsmoBTS IP is reachable from outside. E.g.:

   oml remote-ip 10.0.0.10
   ...
   rtp bind-ip 0.0.0.0

Your personal GSM network is now be ready for use!

**Note:** run the system either in faraday cage or with proper licenses.

### Attach to running container

    docker ps --no-trunc # note full container ID
    sudo lxc-attach -n FULL_CONTAINER_ID
    telnet localhost 4242 # OpenBSC VTY
