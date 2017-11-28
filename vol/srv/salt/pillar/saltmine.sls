mine_functions:
  network.ip_addrs: eth0
  hostname:
    - mine_function: grains.get
    - nodename
  eth0:
    - mine_function: network.ip_addrs
    - eth0
mine_interval: 2
