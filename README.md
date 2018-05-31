# Description
This is an effort to automate the installation process of Arch. The end goal is to boot from
the live media, connect to the internet, execute the following command and enter some basic
information. The script should do the rest.

```bash
bash -c "$(wget https://raw.githubusercontent.com/nickbatsaras/Arch-Wizard/master/bootstrap.sh -O -)"
```

# Notes
- Currently experimental
- This is not to be used as a generic Arch install
- Currently it only installs on computers with BIOS (no UEFI yet)
