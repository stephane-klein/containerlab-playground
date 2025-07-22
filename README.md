# Containerlab playground

More information, see: https://notes.sklein.xyz/2025-07-20_1241/

```sh
$ sudo dnf config-manager addrepo --set=baseurl="https://netdevops.fury.site/yum/" && \
$ echo "gpgcheck=0" | sudo tee -a /etc/yum.repos.d/netdevops.fury.site_yum_.repo
$ sudo dnf install containerlab
$ sudo usermod -aG clab_admins stephane && newgrp clab_admins
$ sudo semanage fcontext -a -t textrel_shlib_t $(which containerlab)
$ sudo restorecon $(which containerlab)
```

At the moment, I don't understand why this command without `sudo` doesn't work:

```
$ containerlab deploy
11:25:54 INFO Containerlab started version=0.69.0

   ERROR 

  Failed to read topology file: stat /home/stephane/git/github.com/stephane-klein/containerlab-playground/network-a-
  b.clab.yaml: permission denied.
```


```sh
$ sudo containerlab deploy
11:27:03 INFO Containerlab started version=0.69.0
11:27:03 INFO Parsing & checking topology file=network-a-b.clab.yaml
11:27:03 INFO Creating docker network name=net-custom IPv4 subnet="" IPv6 subnet=2001:db8:a::0/48 MTU=0
11:27:03 INFO Creating lab directory path=/home/stephane/git/github.com/stephane-klein/containerlab-playground/clab-network-a
11:27:04 INFO Creating container name=vm-b1
11:27:04 INFO Creating container name=vm-a1
11:27:04 INFO Creating container name=vm-a2
11:27:04 INFO Creating container name=vm-a3
11:27:04 INFO Adding host entries path=/etc/hosts
11:27:04 INFO Adding SSH config for nodes path=/etc/ssh/ssh_config.d/clab-network-a.conf
╭──────────────────────┬───────────────────┬─────────┬─────────────────╮
│         Name         │     Kind/Image    │  State  │  IPv4/6 Address │
├──────────────────────┼───────────────────┼─────────┼─────────────────┤
│ clab-network-a-vm-a1 │ linux             │ running │ 192.168.0.2     │
│                      │ mitchv85/ohv-host │         │ 2001:db8:a:1::1 │
├──────────────────────┼───────────────────┼─────────┼─────────────────┤
│ clab-network-a-vm-a2 │ linux             │ running │ 192.168.0.3     │
│                      │ mitchv85/ohv-host │         │ 2001:db8:a:1::2 │
├──────────────────────┼───────────────────┼─────────┼─────────────────┤
│ clab-network-a-vm-a3 │ linux             │ running │ 192.168.0.4     │
│                      │ mitchv85/ohv-host │         │ 2001:db8:a:1::3 │
├──────────────────────┼───────────────────┼─────────┼─────────────────┤
│ clab-network-a-vm-b1 │ linux             │ running │ 192.168.0.5     │
│                      │ mitchv85/ohv-host │         │ 2001:db8:a:2::5 │
╰──────────────────────┴───────────────────┴─────────┴─────────────────╯
```

I can connect with *ssh*:

```sh
$ ssh admin@clab-network-a-vm-a1
admin@vm-a1:~$ exit
```

I can run a command on all nodes:

```
$ sudo containerlab exec -t network-a-b.clab.yaml --cmd 'ip addr'
11:29:52 INFO Parsing & checking topology file=network-a-b.clab.yaml
11:29:52 INFO Executed command node=clab-network-a-vm-a2 command="ip addr"
  stdout=
  │ 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
  │     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  │     inet 127.0.0.1/8 scope host lo
  │        valid_lft forever preferred_lft forever
  │     inet6 ::1/128 scope host
  │        valid_lft forever preferred_lft forever
  │ 2: eth0@if192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
  │     link/ether aa:86:42:84:81:de brd ff:ff:ff:ff:ff:ff link-netnsid 0
  │     inet 192.168.0.3/20 brd 192.168.15.255 scope global eth0
  │        valid_lft forever preferred_lft forever
  │     inet6 2001:db8:a:1::2/48 scope global nodad
  │        valid_lft forever preferred_lft forever
  │     inet6 fe80::a886:42ff:fe84:81de/64 scope link
  │        valid_lft forever preferred_lft forever

11:29:52 INFO Executed command node=clab-network-a-vm-a3 command="ip addr"
  stdout=
  │ 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
  │     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  │     inet 127.0.0.1/8 scope host lo
  │        valid_lft forever preferred_lft forever
  │     inet6 ::1/128 scope host
  │        valid_lft forever preferred_lft forever
  │ 2: eth0@if193: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
  │     link/ether b2:42:6c:2b:d0:9d brd ff:ff:ff:ff:ff:ff link-netnsid 0
  │     inet 192.168.0.4/20 brd 192.168.15.255 scope global eth0
  │        valid_lft forever preferred_lft forever
  │     inet6 2001:db8:a:1::3/48 scope global nodad
  │        valid_lft forever preferred_lft forever
  │     inet6 fe80::b042:6cff:fe2b:d09d/64 scope link
  │        valid_lft forever preferred_lft forever

11:29:52 INFO Executed command node=clab-network-a-vm-a1 command="ip addr"
  stdout=
  │ 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
  │     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  │     inet 127.0.0.1/8 scope host lo
  │        valid_lft forever preferred_lft forever
  │     inet6 ::1/128 scope host
  │        valid_lft forever preferred_lft forever
  │ 2: eth0@if191: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
  │     link/ether 26:9f:87:52:d6:1c brd ff:ff:ff:ff:ff:ff link-netnsid 0
  │     inet 192.168.0.2/20 brd 192.168.15.255 scope global eth0
  │        valid_lft forever preferred_lft forever
  │     inet6 2001:db8:a:1::1/48 scope global nodad
  │        valid_lft forever preferred_lft forever
  │     inet6 fe80::249f:87ff:fe52:d61c/64 scope link
  │        valid_lft forever preferred_lft forever

11:29:52 INFO Executed command node=clab-network-a-vm-b1 command="ip addr"
  stdout=
  │ 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
  │     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  │     inet 127.0.0.1/8 scope host lo
  │        valid_lft forever preferred_lft forever
  │     inet6 ::1/128 scope host
  │        valid_lft forever preferred_lft forever
  │ 2: eth0@if194: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
  │     link/ether e2:81:7b:c7:eb:64 brd ff:ff:ff:ff:ff:ff link-netnsid 0
  │     inet 192.168.0.5/20 brd 192.168.15.255 scope global eth0
  │        valid_lft forever preferred_lft forever
  │     inet6 2001:db8:a:2::5/48 scope global nodad
  │        valid_lft forever preferred_lft forever
  │     inet6 fe80::e081:7bff:fec7:eb64/64 scope link
  │        valid_lft forever preferred_lft forever
```

Or a command on a single node:

```sh
$ sudo containerlab exec -t network-a-b.clab.yaml --label clab-node-name=vm-a1 --cmd 'ip addr'
11:02:44 INFO Parsing & checking topology file=network-a-b.clab.yaml
11:02:44 INFO Executed command node=clab-network-a-vm-a1 command="ip addr"
  stdout=
  │ 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
  │     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  │     inet 127.0.0.1/8 scope host lo
  │        valid_lft forever preferred_lft forever
  │     inet6 ::1/128 scope host
  │        valid_lft forever preferred_lft forever
```

I'm doing some ping tests

```sh
$ ssh admin@clab-network-a-vm-a1
admin@vm-a1:~$ ping -6 "2001:db8:a:1::2"
PING 2001:db8:a:1::2(2001:db8:a:1::2) 56 data bytes
64 bytes from 2001:db8:a:1::2: icmp_seq=1 ttl=64 time=0.132 ms
^C
--- 2001:db8:a:1::2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.132/0.132/0.132/0.000 ms
admin@vm-a1:~$ ping -6 "2001:db8:a:1::3"
PING 2001:db8:a:1::3(2001:db8:a:1::3) 56 data bytes
64 bytes from 2001:db8:a:1::3: icmp_seq=1 ttl=64 time=0.108 ms
^C
--- 2001:db8:a:1::3 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.108/0.108/0.108/0.000 ms
admin@vm-a1:~$ ping -6 "2001:db8:a:2::5"
PING 2001:db8:a:2::5(2001:db8:a:2::5) 56 data bytes
64 bytes from 2001:db8:a:2::5: icmp_seq=1 ttl=64 time=0.146 ms
^C
--- 2001:db8:a:2::5 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.146/0.146/0.146/0.000 ms
```

However, for the moment, I haven't managed to achieve my goal of creating two separate networks.

I don't know how to define the ipv6 prefix length of the `eth0` interfaces of the different nodes.
For the moment, all the nodes belong to the same subnet `2001:db8:a::0/48`, whereas I'd like to separate them into two networks:

- `2001:db8:a:1`
- `2001:db8:a:2`

```
# network-a-b.clab.yaml

...

topology:
  nodes:
    vm-a1:
      kind: linux
      # image: alpine-ssh
      # https://hub.docker.com/r/mitchv85/ohv-host
      image: mitchv85/ohv-host
      mgmt-ipv6: 2001:db8:a:1::1
      # Here I don't know how to specify: 2001:db8:a:1::1/64

...

```

Containerlab may not be suitable for this need. 

It might be wise to explore the other alternatives mentioned in https://brianlinkletter.com/2024/02/open-source-network-simulation-roundup-2024/  

Alternatively, this issue could potentially address my objective in the future: https://github.com/srl-labs/containerlab/issues/2513 
