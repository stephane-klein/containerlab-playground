#!/usr/bin/env bash
set -e

# Use this script to generate /README.md:
#
# $ ./scripts/generate-README.sh > README.md 2>&1

stty cols 80
cd "$(dirname "$0")/../"

# I begin with teardown all network
sudo containerlab destroy -t network-a.clab.yaml > /dev/null 2>&1
sudo containerlab destroy -t network-b.clab.yaml > /dev/null 2>&1
sudo containerlab destroy -t network-c.clab.yaml > /dev/null 2>&1

cat << 'EOF'
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
EOF

cat << EOF
At the time of wrting this playground, I am using *containerlab* \`$(containerlab version | grep -oP '(?<=version: )\S+')\`:

\`\`\`
$ containerlab version
EOF

containerlab version

cat << 'EOF'
I create the first network *a*:

```sh
$ sudo containerlab -t network-a.clab.yaml deploy -c
EOF

sudo containerlab -t network-a.clab.yaml deploy -c

cat << 'EOF'
```

Then, I create network *b* and network *c*:

```sh
$ sudo containerlab -t network-b.clab.yaml deploy -c
EOF

sudo containerlab -t network-b.clab.yaml deploy -c

cat << 'EOF'
$ sudo containerlab -t network-c.clab.yaml deploy -c
EOF

sudo containerlab -t network-c.clab.yaml deploy -c

cat << 'EOF'
I can connect to a host via *ssh*:

```sh
$ ssh admin@clab-network-a-vm-a1
admin@vm-a1:~$ exit
```

I can run a command on all nodes:

```sh
$ sudo containerlab exec -t network-a.clab.yaml --cmd 'ip addr'
EOF

sudo containerlab exec -t network-a.clab.yaml --cmd 'ip addr'

cat << 'EOF'
```

Or execute a command on a single node:

```sh
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'hostname'
EOF

sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'hostname'

cat << 'EOF'
```

I am performing ping tests between ‘vm-a1’ and ‘vm-a2’ on the same network:

```sh
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ping -6 -c 1 -q "2001:db8:a:1::3"'
EOF

sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ping -6 -c 1 -q "2001:db8:a:1::3"'

cat << 'EOF'
```

I am performing ping tests between ‘vm-a1’ and ‘vm-b1’ on two different network:

```sh
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ping -6 -c 1 -q "2001:db8:a:2::5"'
EOF

sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ping -6 -c 1 -q "2001:db8:a:2::5"'

cat << 'EOF'
```

This communication works because a default route is defined to `br01`:

```
$ sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ip -6 route'
EOF

sudo containerlab exec -t network-a.clab.yaml --label clab-node-name=vm-a1 --cmd 'ip -6 route'

cat << 'EOF'
```

And because routes are defined on my host system:

```
$ sudo ip -6 route show | grep "2001:db8:a:"
EOF

sudo ip -6 route show | grep "2001:db8:a:"

cat << 'EOF'
```

## Teardown

```
$ ./scripts/teardown.sh
```
EOF
