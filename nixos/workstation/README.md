# NixOS Installation: Workstation

## Download the installer

* Grab the [minimal ISO image](https://nixos.org/download#nixos-iso) for
  your architecture
* Copy it onto a USB drive
    ```
    # dd if=<path/to/nixos.iso> of=<path/to/usb-drive> bs=4M status=progress
    ```

## Configure UEFI

*This step is only required if installing on a newer system with UEFI.*

* Disable `Secure Boot Control`
* Enable `Launch CSM`
* Set first boot option to `UEFI: USB Flash DISK 1100`

## Partition the hard drive

*Depending on the system, `fdisk` might work, or `gdisk` might be
needed.  The target drive is something like /dev/sda, dev/sdb, or
/dev/nvme0n1.*

Using `fdisk` on `/dev/nvme0n1`:

* Create partition 1 with 512MB and type `ef` for `EFI (FAT-12/16/32)`
* Create partition 2 with the rest of the drive and type `8e` for `Linux LVM`

Using `gdisk` on `/dev/nvme0n1`:

* Create partition 1 with 512MB and type ef00
* Create partition 2 with the rest of the drive and type `8e00` for `Linux LVM`

## Set up encryption

```
# cryptsetup luksFormat /dev/nvme0n1p2
# cryptsetup luksOpen /dev/nvme0n1p2 enc-pv
# pvcreate /dev/mapper/enc-pv
# vgcreate vg /dev/mapper/enc-pv
```

Create the root partition.  To use all of the available space, specify
an overly large number of extents (e.g. `-l 99999999`).  The command
will fail and let you know how many are actually available.

```
# lvcreate -l 28355 -n root vg
```

## Format partitions

```
# mkfs.fat /dev/nvme0n1p1
# mkfs.ext4 -O dir_index -j -L root /dev/vg/root
```

## Mount partitions

```
# mount /dev/vg/root /mnt
# mkdir /mnt/boot
# mount /dev/nvme0n1p1 /mnt/boot
```

## Prep NixOS installation

```
# nixos-generate-config --root /mnt
# vim /mnt/etc/nixos/configuration.nix
```

## Decrypt on boot

*/mnt/etc/nixos/configuration.nix:*

```
boot.initrd.luks.devices = {
  root = {
    device = "/dev/disk/by-uuid/abc-123-symlink-to-dev-nvme0n1p2";
    preLVM = true;
  };
};
```

## Fix `wpa_supplicant`

Be sure to enable wireless in *configuration.nix*.  Then add this to
*/mnt/etc/wpa_supplicant.conf*:

```
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=wheel
update_config=1

network={
  ssid="prettyflyforawifi"
  psk="alligator3"
  proto=RSN
  key_mgmt=WPA-PSK
  pairwise=CCMP
  auth_alg=OPEN
  bgscan="simple:30:-45:300"
}
```

## Install NixOS

```
# nixos-install
```
