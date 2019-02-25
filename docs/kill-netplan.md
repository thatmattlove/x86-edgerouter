# Kill Netplan
[Netplan](https://netplan.io) was introduced with Ubuntu 18.04 and while I actually much prefer it to `ifupdown`, it lacks some features and generally complicates things with this (or at least, my) setup.

### Reinstall `ifupdown`

```console
# apt-get update
# apt-get install ifupdown
```

### Configure
Edit your `/etc/network/interfaces` file with the following:

```
#
source /etc/network/interfaces.d/*
#
auto lo
iface lo inet loopback
# ↓ add your standard interface configurations ↓
```

### Switch

```console
# ifdown --force <device1> <device2> <device3> ... && ifup -a
# systemctl unmask networking
# systemctl enable networking
# systemctl restart networking
```

### Stop & Purge Netplan

```console
# systemctl stop systemd-networkd.socket systemd-networkd networkd-dispatcher systemd-networkd-wait-online
# systemctl disable systemd-networkd.socket systemd-networkd networkd-dispatcher systemd-networkd-wait-online
# systemctl mask systemd-networkd.socket systemd-networkd networkd-dispatcher systemd-networkd-wait-online
# apt-get --assume-yes purge nplan netplan.io
```

### Fix your DNS configuration:
Edit `/etc/systemd/resolved.conf`

```
DNS=1.1.1.1
DNS=1.0.0.1
```

#### Restart `systemd-resolved`
```console
# systemctl restart systemd-resolved
```
