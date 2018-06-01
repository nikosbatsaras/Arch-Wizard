# Description
## What this project is:
An effort to automate the process of manually:
- Installing Arch Linux
- Installing all the applications i use
- and configuring those applications the way i prefer

## What this project is *not*:
- A *generic* Arch Linux installation
- An *interactive* Arch Linux installation

# Setup
## Preamble
Before proceeding:
- You need an MBR partition table (no GPT support yet)
- The script automatically partitions the device you specify
- Ext4 is used as the filesystem of the new partition
- Make sure your partition numbers are contiguous

Example lsblk output should be similar to this:
```
sda
└─sda1
└─sda2
└─sda3
```
and **not** to this:
```
sda
└─sda1
└─sda2
└─sda5
```

## Installation
After reading the above, if you still want to proceed:
- Burn an Arch iso to a live media (e.g usb)
- Boot from that media
- Connect to the internet
- Execute the following command:

```bash
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/Arch-Wizard/master/bootstrap.sh -O -)"
```

It will ask you for some basic info at start and then the script should do the
rest.

# Notes
- Still experimental
