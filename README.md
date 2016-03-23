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

    env BRIDGED_NETWORK=no vagrant up
    vagrant ssh
    cd /vagrant

### Build Docker image

    docker build -rm -t shamrin/osmonitb .

### Reboot Vagrant VM

*(skip if running Ubuntu natively)*

Reboot the VM and run `ifconfig` to check Docker host IP address:

    exit
    vagrant halt
    vagrant up --no-provision # with bridged network
    vagrant ssh
    ifconfig

**Note:** VM directly connects (via bridge) to the same network as your host, so make sure you can trust your network.

### Run Docker container

    docker run -v $HOME/db:/var/db -i -t -p 3002:3002 -p 3003:3003 -p 30000:30000/udp -p 30001:30001/udp -p 30002:30002/udp -p 30003:30003/udp -p 30004:30004/udp -p 30005:30005/udp -p 30006:30006/udp -p 30007:30007/udp -p 30008:30008/udp -p 30009:30009/udp -p 30010:30010/udp -p 30011:30011/udp -p 30012:30012/udp shamrin/osmonitb start-nitb -i 10.0.0.10 GSM1800 10 20

Replace `10.0.0.10` with the IP address of Docker host, `GSM1800` with the band you use, `10` and `20` with your [ARFCNs][7] (run `... start-nitb -h` for help).

**Note:** Docker [doesn't support port ranges][6] yet, that's why (RTP) ports has to be all specified one by one. Add ports to support more phone calls.

[6]: https://github.com/dotcloud/docker/issues/1834
[7]: https://en.wikipedia.org/wiki/Absolute_radio-frequency_channel_number

### Configure OsmoBTS

Set `oml remote-ip` in OsmoBTS config to point to OpenBSC IP address (the same as above) and make sure OsmoBTS IP is reachable. E.g.:

    oml remote-ip 10.0.0.10
    rtp bind-ip 0.0.0.0

Your personal GSM network is now ready!

**Note:** run either in faraday cage or with proper licenses.

### Attach to running container

    docker ps --no-trunc # note full container ID
    sudo lxc-attach -n FULL_CONTAINER_ID
    telnet localhost 4242 # OpenBSC VTY

### See also

* https://habrahabr.ru/post/213845/ (in Russian)
