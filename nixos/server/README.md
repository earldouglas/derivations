# NixOS Installation: Server

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

Using `fdisk` on `/dev/sda`:

* Create partition 1 with 512MB and type `ef` for `EFI (FAT-12/16/32)`
* Create partition 2 with the rest of the drive and type `83` for `Linux filesystem`

Using `gdisk` on `/dev/sda`:

* Create partition 1 with 512MB and type ef00
* Create partition 2 with the rest of the drive and type `8300` for `Linux filesystem`

## Format partitions

```
# mkfs.fat /dev/sda1
# mkfs.ext4 -O dir_index -j -L root /dev/sda2
```

## Mount partitions

```
# mount /dev/sda2 /mnt
# mkdir /mnt/boot
# mount /dev/sda1 /mnt/boot
```

## Optional: Set up RAID 1 for */home*

```
# sudo mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/sdc /dev/sdd
# mkfs.ext4 -F /dev/md0
# mkdir /mnt/home
# mount /dev/md0 /mnt/home
```

## Install NixOS

```
# nixos-generate-config --root /mnt
# vim /mnt/etc/nixos/configuration.nix
# nixos-install
```
