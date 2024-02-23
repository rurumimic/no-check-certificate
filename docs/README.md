# Linux Documentations Link

- Ubuntu
- CentOS

---

## Ubuntu

### Focal 20.04

- man: [update-ca-certificates](http://manpages.ubuntu.com/manpages/focal/man8/update-ca-certificates.8.html) - update `/etc/ssl/certs` and ca-certificates.crt
- package: [ca-certificates](https://packages.ubuntu.com/focal/ca-certificates)
  - [change logs](https://launchpad.net/ubuntu/+source/ca-certificates/+changelog)

### Snap

- System options
  - [store-certs](https://snapcraft.io/docs/system-options#heading--store-certs)

## CentOS

### CentOS 7

- RedHat: [Using Shared System Certificates](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-shared-system-certificates)
- `/etc/pki/ca-trust/`
  - `/etc/pki/ca-trust/source/anchors/`
- `/usr/share/pki/ca-trust-source/`
  - `/usr/share/pki/ca-trust-source/anchors/`
- Run: `update-ca-trust`

