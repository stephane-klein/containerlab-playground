# Containerlab playground

More information, see these notes:

- https://notes.sklein.xyz/2025-07-20_1241/
- https://notes.sklein.xyz/2025-07-24_2231/
- [Why I get "WARN iptables check error: exit status 111. Output:" when I launch containerlab without sudo?](https://github.com/srl-labs/containerlab/discussions/2814)

```sh
$ sudo dnf config-manager addrepo --set=baseurl="https://netdevops.fury.site/yum/" && \
$ echo "gpgcheck=0" | sudo tee -a /etc/yum.repos.d/netdevops.fury.site_yum_.repo
$ sudo dnf install containerlab
$ sudo usermod -aG clab_admins stephane && newgrp clab_admins
$ sudo semanage fcontext -a -t textrel_shlib_t $(which containerlab)
$ sudo restorecon $(which containerlab)
```
At the time of wrting this playground, I am using *containerlab* `0.69.3`:

```
$ containerlab version
  ____ ___  _   _ _____  _    ___ _   _ _____ ____  [38;2;0;201;255m_       _     [0m
 / ___/ _ \| \ | |_   _|/ \  |_ _| \ | | ____|  _ \[38;2;0;201;255m| | __ _| |__  [0m
| |  | | | |  \| | | | / _ \  | ||  \| |  _| | |_) [38;2;0;201;255m| |/ _` | '_ \ [0m
| |__| |_| | |\  | | |/ ___ \ | || |\  | |___|  _ <[38;2;0;201;255m| | (_| | |_) |[0m
 \____\___/|_| \_| |_/_/   \_\___|_| \_|_____|_| \_\[38;2;0;201;255m_|\__,_|_.__/ [0m

    version: 0.69.3
     commit: 49ee599b
       date: 2025-08-06T21:02:24Z
     source: https://github.com/srl-labs/containerlab
 rel. notes: https://containerlab.dev/rn/0.69/#0693
I create the first network *a*:

```sh
$ sudo containerlab -t network-a.clab.yaml deploy -c
16:44:13 INFO Containerlab started version=0.69.3
16:44:13 INFO Parsing & checking topology file=network-a.clab.yaml
16:44:13 INFO Removing directory path=/home/stephane/git/github.com/stephane-klein/containerlab-playground/clab-network-a
16:44:13 INFO Creating docker network name=network-a IPv4 subnet="" IPv6 subnet=2001:db8:a:1::0/64 MTU=0
16:44:13 INFO Creating lab directory path=/home/stephane/git/github.com/stephane-klein/containerlab-playground/clab-network-a
16:44:14 INFO Creating container name=vm-a2
16:44:14 INFO Creating container name=vm-a3
16:44:14 INFO Creating container name=vm-a1
16:44:14 INFO Adding host entries path=/etc/hosts
16:44:14 INFO Adding SSH config for nodes path=/etc/ssh/ssh_config.d/clab-network-a.conf
You are on the latest version (0.69.3)
[1m╭[0m[1m──────────────────────[0m[1m┬[0m[1m───────────────────[0m[1m┬[0m[1m─────────[0m[1m┬[0m[1m─────────────────[0m[1m╮[0m
[1m│[0m[1m         Name         [0m[1m│[0m[1m     Kind/Image    [0m[1m│[0m[1m  State  [0m[1m│[0m[1m  IPv4/6 Address [0m[1m│[0m
[1m├[0m[1m──────────────────────[0m[1m┼[0m[1m───────────────────[0m[1m┼[0m[1m─────────[0m[1m┼[0m[1m─────────────────[0m[1m┤[0m
│ clab-network-a-vm-a1 │ linux             │ running │ 172.18.0.4      │
│                      │ mitchv85/ohv-host │         │ 2001:db8:a:1::2 │
├──────────────────────┼───────────────────┼─────────┼─────────────────┤
│ clab-network-a-vm-a2 │ linux             │ running │ 172.18.0.2      │
│                      │ mitchv85/ohv-host │         │ 2001:db8:a:1::3 │
├──────────────────────┼───────────────────┼─────────┼─────────────────┤
│ clab-network-a-vm-a3 │ linux             │ running │ 172.18.0.3      │
│                      │ mitchv85/ohv-host │         │ 2001:db8:a:1::4 │
╰──────────────────────┴───────────────────┴─────────┴─────────────────╯
```

Then, I create network *b* and network *c*:

```sh
$ sudo containerlab -t network-b.clab.yaml deploy -c
16:44:14 INFO Containerlab started version=0.69.3
16:44:14 INFO Parsing & checking topology file=network-b.clab.yaml
16:44:14 INFO Removing directory path=/home/stephane/git/github.com/stephane-klein/containerlab-playground/clab-network-b
16:44:14 INFO Creating docker network name=network-b IPv4 subnet="" IPv6 subnet=2001:db8:a:2::0/64 MTU=0
16:44:14 INFO Creating lab directory path=/home/stephane/git/github.com/stephane-klein/containerlab-playground/clab-network-b
16:44:14 INFO Creating container name=vm-b2
16:44:14 INFO Creating container name=vm-b1
16:44:15 INFO Adding host entries path=/etc/hosts
16:44:15 INFO Adding SSH config for nodes path=/etc/ssh/ssh_config.d/clab-network-b.conf
You are on the latest version (0.69.3)
[1m╭[0m[1m──────────────────────[0m[1m┬[0m[1m───────────────────[0m[1m┬[0m[1m─────────[0m[1m┬[0m[1m─────────────────[0m[1m╮[0m
[1m│[0m[1m         Name         [0m[1m│[0m[1m     Kind/Image    [0m[1m│[0m[1m  State  [0m[1m│[0m[1m  IPv4/6 Address [0m[1m│[0m
[1m├[0m[1m──────────────────────[0m[1m┼[0m[1m───────────────────[0m[1m┼[0m[1m─────────[0m[1m┼[0m[1m─────────────────[0m[1m┤[0m
│ clab-network-b-vm-b1 │ linux             │ running │ 172.19.0.2      │
│                      │ mitchv85/ohv-host │         │ 2001:db8:a:2::5 │
├──────────────────────┼───────────────────┼─────────┼─────────────────┤
│ clab-network-b-vm-b2 │ linux             │ running │ 172.19.0.3      │
│                      │ mitchv85/ohv-host │         │ 2001:db8:a:2::6 │
╰──────────────────────┴───────────────────┴─────────┴─────────────────╯
$ sudo containerlab -t network-c.clab.yaml deploy -c
16:44:15 INFO Containerlab started version=0.69.3
16:44:15 INFO Parsing & checking topology file=network-c.clab.yaml
16:44:15 INFO Removing directory path=/home/stephane/git/github.com/stephane-klein/containerlab-playground/clab-network-c
16:44:15 INFO Creating docker network name=network-c IPv4 subnet="" IPv6 subnet=2001:db8:b::0/48 MTU=0
16:44:15 INFO Creating lab directory path=/home/stephane/git/github.com/stephane-klein/containerlab-playground/clab-network-c
16:44:15 INFO Creating container name=vm-d3
16:44:15 INFO Creating container name=vm-c2
16:44:15 INFO Creating container name=vm-c1
16:44:15 INFO Creating container name=vm-c3
16:44:16 INFO Adding host entries path=/etc/hosts
16:44:16 INFO Adding SSH config for nodes path=/etc/ssh/ssh_config.d/clab-network-c.conf
You are on the latest version (0.69.3)
[1m╭[0m[1m──────────────────────[0m[1m┬[0m[1m───────────────────[0m[1m┬[0m[1m─────────[0m[1m┬[0m[1m───────────────────[0m[1m╮[0m
[1m│[0m[1m         Name         [0m[1m│[0m[1m     Kind/Image    [0m[1m│[0m[1m  State  [0m[1m│[0m[1m   IPv4/6 Address  [0m[1m│[0m
[1m├[0m[1m──────────────────────[0m[1m┼[0m[1m───────────────────[0m[1m┼[0m[1m─────────[0m[1m┼[0m[1m───────────────────[0m[1m┤[0m
│ clab-network-c-vm-c1 │ linux             │ running │ 172.23.0.4        │
│                      │ mitchv85/ohv-host │         │ 2001:db8:b:1::4   │
├──────────────────────┼───────────────────┼─────────┼───────────────────┤
│ clab-network-c-vm-c2 │ linux             │ running │ 172.23.0.5        │
│                      │ mitchv85/ohv-host │         │ 2001:db8:b:1::2   │
├──────────────────────┼───────────────────┼─────────┼───────────────────┤
│ clab-network-c-vm-c3 │ linux             │ running │ 172.23.0.3        │
│                      │ mitchv85/ohv-host │         │ 2001:db8:b:2::1   │
├──────────────────────┼───────────────────┼─────────┼───────────────────┤
│ clab-network-c-vm-d3 │ linux             │ running │ 172.23.0.2        │
│                      │ mitchv85/ohv-host │         │ 2001:db8:b:2::1:3 │
╰──────────────────────┴───────────────────┴─────────┴───────────────────╯
I can connect to a host via *ssh*:

```sh
$ ssh admin@clab-network-a-vm-a1
admin@vm-a1:~$ exit
```

I can run a command on all nodes:

```sh
$ sudo containerlab exec -t network-a.clab.yaml --cmd 'ip addr'
16:44:16 INFO Parsing & checking topology file=network-a.clab.yaml
16:44:16 INFO Executed command node=clab-network-a-vm-a3 command="ip addr"
  stdout=
  │ 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
  │     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  │     inet 127.0.0.1/8 scope host lo
  │        valid_lft forever preferred_lft forever
  │     inet6 ::1/128 scope host 
  │        valid_lft forever preferred_lft forever
  │ 2: eth0@if296: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
  │     link/ether 12:ea:5e:96:42:e2 brd ff:ff:ff:ff:ff:ff link-netnsid 0
  │     inet 172.18.0.3/16 brd 172.18.255.255 scope global eth0
  │        valid_lft forever preferred_lft forever
  │     inet6 2001:db8:a:1::4/64 scope global nodad 
  │        valid_lft forever preferred_lft forever
  │     inet6 fe80::10ea:5eff:fe96:42e2/64 scope link 
  │        valid_lft forever preferred_lft forever

16:44:16 INFO Executed command node=clab-network-a-vm-a2 command="ip addr"
  stdout=
  │ 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
  │     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  │     inet 127.0.0.1/8 scope host lo
  │        valid_lft forever preferred_lft forever
  │     inet6 ::1/128 scope host 
  │        valid_lft forever preferred_lft forever
  │ 2: eth0@if295: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
  │     link/ether e2:78:a8:59:b6:ca brd ff:ff:ff:ff:ff:ff link-netnsid 0
  │     inet 172.18.0.2/16 brd 172.18.255.255 scope global eth0
  │        valid_lft forever preferred_lft forever
  │     inet6 2001:db8:a:1::3/64 scope global nodad 
  │        valid_lft forever preferred_lft forever
  │     inet6 fe80::e078:a8ff:fe59:b6ca/64 scope link 
  │        valid_lft forever preferred_lft forever

16:44:16 INFO Executed command node=clab-network-a-vm-a1 command="ip addr"
  stdout=
  │ 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
  │     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  │     inet 127.0.0.1/8 scope host lo
  │        valid_lft forever preferred_lft forever
  │     inet6 ::1/128 scope host 
  │        valid_lft forever preferred_lft forever
  │ 2: eth0@if297: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
  │     link/ether d6:a1:2f:f8:16:21 brd ff:ff:ff:ff:ff:ff link-netnsid 0
  │     inet 172.18.0.4/16 brd 172.18.255.255 scope global eth0
  │        valid_lft forever preferred_lft forever
  │     inet6 2001:db8:a:1::2/64 scope global nodad 
  │        valid_lft forever preferred_lft forever
  │     inet6 fe80::d4a1:2fff:fef8:1621/64 scope link 
  │        valid_lft forever preferred_lft forever
  │ 3: br01: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default 
  │     link/ether 82:b7:49:95:93:cd brd ff:ff:ff:ff:ff:ff
  │     inet6 fe80::80b7:49ff:fe95:93cd/64 scope link 
  │        valid_lft forever preferred_lft forever

```

Or execute a command on a single node:

```sh
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'hostname'
16:44:16 INFO Parsing & checking topology file=network-a.clab.yaml
16:44:16 INFO Executed command node=clab-network-a-vm-a1 command=hostname
  stdout=
  │ vm-a1

```

I am performing ping tests between ‘vm-a1’ and ‘vm-a2’ on the same network:

```sh
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ping -6 -c 1 -q "2001:db8:a:1::3"'
16:44:16 INFO Parsing & checking topology file=network-a.clab.yaml
16:44:16 INFO Executed command node=clab-network-a-vm-a1 command="ping -6 -c 1 -q 2001:db8:a:1::3"
  stdout=
  │ PING 2001:db8:a:1::3(2001:db8:a:1::3) 56 data bytes
  │ 
  │ --- 2001:db8:a:1::3 ping statistics ---
  │ 1 packets transmitted, 1 received, 0% packet loss, time 0ms
  │ rtt min/avg/max/mdev = 0.093/0.093/0.093/0.000 ms

```

I am performing ping tests between ‘vm-a1’ and ‘vm-b1’ on two different network:

```sh
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ping -6 -c 1 -q "2001:db8:a:2::5"'
16:44:16 INFO Parsing & checking topology file=network-a.clab.yaml
16:44:16 INFO Executed command node=clab-network-a-vm-a1 command="ping -6 -c 1 -q 2001:db8:a:2::5"
  stdout=
  │ PING 2001:db8:a:2::5(2001:db8:a:2::5) 56 data bytes
  │ 
  │ --- 2001:db8:a:2::5 ping statistics ---
  │ 1 packets transmitted, 1 received, 0% packet loss, time 0ms
  │ rtt min/avg/max/mdev = 0.245/0.245/0.245/0.000 ms

```

This communication works because a default route is defined to `br01`:

```
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ip -6 route'
16:44:16 INFO Parsing & checking topology file=network-a.clab.yaml
16:44:16 INFO Executed command node=clab-network-a-vm-a1 command="ip -6 route"
  stdout=
  │ 2001:db8:a:1::/64 dev eth0 proto kernel metric 256 pref medium
  │ fe80::/64 dev eth0 proto kernel metric 256 pref medium
  │ fe80::/64 dev br01 proto kernel metric 256 pref medium
  │ default via 2001:db8:a:1::1 dev eth0 metric 1024 pref medium

```

And because routes are defined on my host system:

```
$ sudo ip -6 route show | grep "2001:db8:a:"
2001:db8:a:1::/64 dev br-47382e038080 proto kernel metric 256 pref medium
2001:db8:a:2::/64 dev br-20eff0aa16ee proto kernel metric 256 pref medium
```

## Teardown

```
$ ./scripts/teardown.sh
```
