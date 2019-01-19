# Hardware

Mellanox ConnectX-4 MCX4121A-ACUT (25GbE dual-port SFP28)

# Drivers

[Linux Drivers](http://www.mellanox.com/page/products_dyn?product_family=27&mtag=linux_driver)

## Download

```console
# wget http://www.mellanox.com/downloads/ofed/MLNX_EN-4.5-1.0.1.0/mlnx-en-4.5-1.0.1.0-ubuntu18.04-x86_64.tgz
# tar -zxf mlnx-en-4.5-1.0.1.0-ubuntu18.04-x86_64.tgz
```

## Configure `apt` installation method

### Sources

* [Driver User Manual](http://www.mellanox.com/related-docs/prod_software/Mellanox_EN_for_Linux_User_Manual_v4_5.pdf)

### Move Driver Files to Appropriate Location
```console
# rsync -ar ./mlnx-en-4.5-1.0.1.0-ubuntu18.04-x86_64 /var/lib/local/
# chown -R root:root /var/lib/local/mlnx-en-4.5-1.0.1.0-ubuntu18.04-x86_64
```

### Create `apt` source

```console
# echo "deb file:/var/lib/local/mlnx-en-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS_ETH ./" >> /etc/apt/sources.list.d/mlnx_en.list
```

### Download & Install Mellanox GPG Key

```console
# wget -qO - http://www.mellanox.com/downloads/ofed/RPM-GPG-KEY-Mellanox | apt-key add -
OK # ← Message if successful
```

### Update Local Repository & Install Packages

```console
# apt-get update
# apt-get install -y mlnx-en-eth-only
```

The install will generate some output and should end with something like:

```console
DKMS: install completed.
Setting up mstflint (4.11.0-1.5.g264ffeb.45101) ...
Setting up ofed-scripts (4.5-OFED.4.5.1.0.1) ...
Setting up mlnx-en-eth-only (4.5-1.0.1.0) ...
Processing triggers for systemd (237-3ubuntu10.11) ...
Processing triggers for ureadahead (0.100.0-20) ...
#
```

### Update the Firmware
#### Install the Mellanox Firmware Updater
```console
# apt-get install -y mlnx-fw-updater
```

This will the discovererd Mellanox devices on the system, display the current version, target version, and begin the update process:

```console
Device #1:
----------

  Device Type:      ConnectX4LX
  Part Number:      MCX4121A-ACA_Ax
  Description:      ConnectX-4 Lx EN network interface card; 25GbE dual-port SFP28; PCIe3.0 x8; ROHS R6
  PSID:             MT_2420110034
  PCI Device Name:  65:00.0
  Base MAC:         98039b3b8ae6
  Versions:         Current        Available
     FW             14.23.1020     14.24.1000
     PXE            3.5.0504       3.5.0603
     UEFI           14.16.0017     14.17.0011

  Status:           Update required

---------
Found 1 device(s) requiring firmware update...

Device #1: Updating FW ...
```

| Note |
|:-----|
| This might take a while. |

Something that may be obvious to you, but wasn't to me, is that this updater is referring to the *card*, not the port. I.e., this is a dual port card, and `lshw -businfo -class network` will show two PCI devices, but from a Mellanox firmware/driver perspective, it's one card.

## Verify Drivers are in Use
### Sources

* [PCI Vendor IDs](http://pciids.sourceforge.net/v2.2/pci.ids)

List detected **Mellanox** PCI devices and their kernel drivers:

```console
# lspci -k -d 15b3:*:*
65:00.0 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
	Subsystem: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
	Kernel driver in use: mlx5_core # ← Mellanox driver is in use
	Kernel modules: mlx5_core
65:00.1 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
	Subsystem: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
	Kernel driver in use: mlx5_core # ← Mellanox driver is in use
	Kernel modules: mlx5_core
```

Verify the `mlx5_core` drivers are loaded:

```console
# lsmod | grep mlx5_core
mlx5_ib               196608  0
ib_core               225280  5 rdma_cm,iw_cm,ib_iser,mlx5_ib,ib_cm
mlx5_core             544768  1 mlx5_ib
mlxfw                  20480  1 mlx5_core
devlink                45056  1 mlx5_core
ptp                    20480  3 i40e,igb,mlx5_core
```

| Note |
|:-----|
| The `mlx5_core` driver applies to both the ConnectX-4 and ConnectX-5 cards. |
