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
11:21:14 INFO Containerlab started version=0.69.3
11:21:14 INFO Parsing & checking topology file=network-a.clab.yaml
11:21:14 INFO Removing directory path=/home/stephane/git/github.com/stephane-klein/containerlab-playground/clab-network-a
11:21:14 INFO Creating docker network name=network-a IPv4 subnet="" IPv6 subnet=2001:db8:a:1::0/64 MTU=0
11:21:15 INFO Creating lab directory path=/home/stephane/git/github.com/stephane-klein/containerlab-playground/clab-network-a
11:21:15 INFO Creating container name=vm-a3
11:21:15 INFO Creating container name=vm-a2
11:21:15 INFO Creating container name=vm-a1
11:21:15 INFO Adding host entries path=/etc/hosts
11:21:15 INFO Adding SSH config for nodes path=/etc/ssh/ssh_config.d/clab-network-a.conf
You are on the latest version (0.69.3)
[1m╭[0m[1m──────────────────────[0m[1m┬[0m[1m───────────────────[0m[1m┬[0m[1m─────────[0m[1m┬[0m[1m─────────────────[0m[1m╮[0m
[1m│[0m[1m         Name         [0m[1m│[0m[1m     Kind/Image    [0m[1m│[0m[1m  State  [0m[1m│[0m[1m  IPv4/6 Address [0m[1m│[0m
[1m├[0m[1m──────────────────────[0m[1m┼[0m[1m───────────────────[0m[1m┼[0m[1m─────────[0m[1m┼[0m[1m─────────────────[0m[1m┤[0m
│ clab-network-a-vm-a1 │ linux             │ running │ 172.18.0.3      │
│                      │ mitchv85/ohv-host │         │ 2001:db8:a:1::2 │
├──────────────────────┼───────────────────┼─────────┼─────────────────┤
│ clab-network-a-vm-a2 │ linux             │ running │ 172.18.0.2      │
│                      │ mitchv85/ohv-host │         │ 2001:db8:a:1::3 │
├──────────────────────┼───────────────────┼─────────┼─────────────────┤
│ clab-network-a-vm-a3 │ linux             │ running │ 172.18.0.4      │
│                      │ mitchv85/ohv-host │         │ 2001:db8:a:1::4 │
╰──────────────────────┴───────────────────┴─────────┴─────────────────╯
```

Then, I create network *b* and network *c*:

```sh
$ sudo containerlab -t network-b.clab.yaml deploy -c
11:21:16 INFO Containerlab started version=0.69.3
11:21:16 INFO Parsing & checking topology file=network-b.clab.yaml
11:21:16 INFO Removing directory path=/home/stephane/git/github.com/stephane-klein/containerlab-playground/clab-network-b
11:21:16 INFO Creating docker network name=network-b IPv4 subnet="" IPv6 subnet=2001:db8:a:2::0/64 MTU=0
11:21:16 INFO Creating lab directory path=/home/stephane/git/github.com/stephane-klein/containerlab-playground/clab-network-b
11:21:16 INFO Creating container name=vm-b2
11:21:16 INFO Creating container name=vm-b1
11:21:16 INFO Adding host entries path=/etc/hosts
11:21:16 INFO Adding SSH config for nodes path=/etc/ssh/ssh_config.d/clab-network-b.conf
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
11:21:16 INFO Containerlab started version=0.69.3
11:21:16 INFO Parsing & checking topology file=network-c.clab.yaml
11:21:16 INFO Removing directory path=/home/stephane/git/github.com/stephane-klein/containerlab-playground/clab-network-c
11:21:16 INFO Creating docker network name=network-c IPv4 subnet="" IPv6 subnet=2001:db8:b::0/48 MTU=0
11:21:17 INFO Creating lab directory path=/home/stephane/git/github.com/stephane-klein/containerlab-playground/clab-network-c
11:21:17 INFO Creating container name=vm-c1
11:21:17 INFO Creating container name=vm-c2
11:21:17 INFO Creating container name=vm-d3
11:21:17 INFO Creating container name=vm-c3
11:21:17 INFO Adding host entries path=/etc/hosts
11:21:17 INFO Adding SSH config for nodes path=/etc/ssh/ssh_config.d/clab-network-c.conf
You are on the latest version (0.69.3)
[1m╭[0m[1m──────────────────────[0m[1m┬[0m[1m───────────────────[0m[1m┬[0m[1m─────────[0m[1m┬[0m[1m───────────────────[0m[1m╮[0m
[1m│[0m[1m         Name         [0m[1m│[0m[1m     Kind/Image    [0m[1m│[0m[1m  State  [0m[1m│[0m[1m   IPv4/6 Address  [0m[1m│[0m
[1m├[0m[1m──────────────────────[0m[1m┼[0m[1m───────────────────[0m[1m┼[0m[1m─────────[0m[1m┼[0m[1m───────────────────[0m[1m┤[0m
│ clab-network-c-vm-c1 │ linux             │ running │ 172.23.0.2        │
│                      │ mitchv85/ohv-host │         │ 2001:db8:b:1::4   │
├──────────────────────┼───────────────────┼─────────┼───────────────────┤
│ clab-network-c-vm-c2 │ linux             │ running │ 172.23.0.4        │
│                      │ mitchv85/ohv-host │         │ 2001:db8:b:1::2   │
├──────────────────────┼───────────────────┼─────────┼───────────────────┤
│ clab-network-c-vm-c3 │ linux             │ running │ 172.23.0.3        │
│                      │ mitchv85/ohv-host │         │ 2001:db8:b:2::1   │
├──────────────────────┼───────────────────┼─────────┼───────────────────┤
│ clab-network-c-vm-d3 │ linux             │ running │ 172.23.0.5        │
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
11:21:18 INFO Parsing & checking topology file=network-a.clab.yaml
11:21:18 INFO Executed command node=clab-network-a-vm-a3 command="ip addr"
  stdout=
  │ 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
  │     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  │     inet 127.0.0.1/8 scope host lo
  │        valid_lft forever preferred_lft forever
  │     inet6 ::1/128 scope host 
  │        valid_lft forever preferred_lft forever
  │ 2: eth0@if401: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
  │     link/ether be:14:f9:57:80:7d brd ff:ff:ff:ff:ff:ff link-netnsid 0
  │     inet 172.18.0.4/16 brd 172.18.255.255 scope global eth0
  │        valid_lft forever preferred_lft forever
  │     inet6 2001:db8:a:1::4/64 scope global nodad 
  │        valid_lft forever preferred_lft forever
  │     inet6 fe80::bc14:f9ff:fe57:807d/64 scope link 
  │        valid_lft forever preferred_lft forever

11:21:18 INFO Executed command node=clab-network-a-vm-a1 command="ip addr"
  stdout=
  │ 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
  │     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  │     inet 127.0.0.1/8 scope host lo
  │        valid_lft forever preferred_lft forever
  │     inet6 ::1/128 scope host 
  │        valid_lft forever preferred_lft forever
  │ 2: eth0@if400: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
  │     link/ether 56:02:6e:b4:02:ac brd ff:ff:ff:ff:ff:ff link-netnsid 0
  │     inet 172.18.0.3/16 brd 172.18.255.255 scope global eth0
  │        valid_lft forever preferred_lft forever
  │     inet6 2001:db8:a:1::2/64 scope global nodad 
  │        valid_lft forever preferred_lft forever
  │     inet6 fe80::5402:6eff:feb4:2ac/64 scope link 
  │        valid_lft forever preferred_lft forever
  │ 3: br01: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default 
  │     link/ether 36:1e:6e:b8:84:d6 brd ff:ff:ff:ff:ff:ff
  │     inet6 fe80::341e:6eff:feb8:84d6/64 scope link 
  │        valid_lft forever preferred_lft forever

11:21:18 INFO Executed command node=clab-network-a-vm-a2 command="ip addr"
  stdout=
  │ 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
  │     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  │     inet 127.0.0.1/8 scope host lo
  │        valid_lft forever preferred_lft forever
  │     inet6 ::1/128 scope host 
  │        valid_lft forever preferred_lft forever
  │ 2: eth0@if399: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
  │     link/ether ba:2a:38:03:41:dc brd ff:ff:ff:ff:ff:ff link-netnsid 0
  │     inet 172.18.0.2/16 brd 172.18.255.255 scope global eth0
  │        valid_lft forever preferred_lft forever
  │     inet6 2001:db8:a:1::3/64 scope global nodad 
  │        valid_lft forever preferred_lft forever
  │     inet6 fe80::b82a:38ff:fe03:41dc/64 scope link 
  │        valid_lft forever preferred_lft forever

```

Or execute a command on a single node:

```sh
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'hostname'
11:21:18 INFO Parsing & checking topology file=network-a.clab.yaml
11:21:18 INFO Executed command node=clab-network-a-vm-a1 command=hostname
  stdout=
  │ vm-a1

```

## Ping performing on `2001:db8...` subnet

I am performing ping tests between `vm-a1` and `vm-a2` on the same network:

```sh
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ping -6 -c 1 -q "2001:db8:a:1::3"'
11:21:18 INFO Parsing & checking topology file=network-a.clab.yaml
11:21:18 INFO Executed command node=clab-network-a-vm-a1 command="ping -6 -c 1 -q 2001:db8:a:1::3"
  stdout=
  │ PING 2001:db8:a:1::3(2001:db8:a:1::3) 56 data bytes
  │ 
  │ --- 2001:db8:a:1::3 ping statistics ---
  │ 1 packets transmitted, 1 received, 0% packet loss, time 0ms
  │ rtt min/avg/max/mdev = 0.121/0.121/0.121/0.000 ms

```

I am performing ping tests between `vm-a1` and `vm-b1` on two different network:

```sh
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ping -6 -c 1 -q "2001:db8:a:2::5"'
11:21:18 INFO Parsing & checking topology file=network-a.clab.yaml
11:21:18 INFO Executed command node=clab-network-a-vm-a1 command="ping -6 -c 1 -q 2001:db8:a:2::5"
  stdout=
  │ PING 2001:db8:a:2::5(2001:db8:a:2::5) 56 data bytes
  │ 
  │ --- 2001:db8:a:2::5 ping statistics ---
  │ 1 packets transmitted, 1 received, 0% packet loss, time 0ms
  │ rtt min/avg/max/mdev = 0.195/0.195/0.195/0.000 ms

```

This communication works because a default route is defined to `br01`:

```
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ip -6 route'
11:21:18 INFO Parsing & checking topology file=network-a.clab.yaml
11:21:18 INFO Executed command node=clab-network-a-vm-a1 command="ip -6 route"
  stdout=
  │ 2001:db8:a:1::/64 dev eth0 proto kernel metric 256 pref medium
  │ fe80::/64 dev eth0 proto kernel metric 256 pref medium
  │ fe80::/64 dev br01 proto kernel metric 256 pref medium
  │ default via 2001:db8:a:1::1 dev eth0 metric 1024 pref medium

```

And because routes are defined on my host system:

```
$ sudo ip -6 route show | grep "2001:db8:a:"
2001:db8:a:1::/64 dev br-ebc7d251fba7 proto kernel metric 256 pref medium
2001:db8:a:2::/64 dev br-98dafc94449b proto kernel metric 256 pref medium
```

## Ping performing on `fe80::...` Link-Local

I am performing ping tests between `vm-a1` to `vm-a2` on the same network, with Link-Local IP address:

```sh
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ping -6 -c1 "fe80::b82a:38ff:fe03:41dc" -I "eth0"'
11:21:18 INFO Parsing & checking topology file=network-a.clab.yaml
11:21:19 INFO Executed command node=clab-network-a-vm-a1 command="ping -6 -c1 fe80::b82a:38ff:fe03:41dc -I eth0"
  stdout=
  │ PING fe80::b82a:38ff:fe03:41dc(fe80::b82a:38ff:fe03:41dc) from :: eth0: 56 data bytes
  │ 64 bytes from fe80::b82a:38ff:fe03:41dc%eth0: icmp_seq=1 ttl=64 time=0.137 ms
  │ 
  │ --- fe80::b82a:38ff:fe03:41dc ping statistics ---
  │ 1 packets transmitted, 1 received, 0% packet loss, time 0ms
  │ rtt min/avg/max/mdev = 0.137/0.137/0.137/0.000 ms

```

Now, I try to perform a ping between `vm-a1` to `vm-b2`, with Link-Local IP address:

```sh
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ping -6 -c1 "fe80::109a:a2ff:feee:fe93" -I "eth0"'
11:21:19 INFO Parsing & checking topology file=network-a.clab.yaml
11:21:22 ERRO Failed to execute command command="ping -6 -c1 fe80::109a:a2ff:feee:fe93 -I eth0" node=clab-network-a-vm-a1 rc=1
  stdout=
  │ PING fe80::109a:a2ff:feee:fe93(fe80::109a:a2ff:feee:fe93) from :: eth0: 56 data bytes
  │ From fe80::5402:6eff:feb4:2ac%eth0 icmp_seq=1 Destination unreachable: Address unreachable
  │ 
  │ --- fe80::109a:a2ff:feee:fe93 ping statistics ---
  │ 1 packets transmitted, 0 received, +1 errors, 100% packet loss, time 0ms
  │ 

  stderr=
  │ ping: Warning: source address might be selected on device other than: eth0

```

but this is a failure, because it is not possible to reach another network with a Link-Local IP address.

## Teardown

```
$ ./scripts/teardown.sh
```
