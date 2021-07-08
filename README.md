# no-check-certificate

How to trust **SELF SIGNED certificates**

- [Usage](#usage)
  - [Append `.gitignore`](#gitignore)
  - [Import your certificates files](#import-your-certificates-files)
  - [Vagrantfile shell provision](#vagrantfile-shell-provision)
    - Ubuntu 20.04 Focal
    - CentOS 7
  - [Vagrant up](#vagrant-up)
- [Test](#test)
  - curl
  - snap
- [Manual](#manual)
  - Ubuntu 20.04 Focal
  - CentOS 7
- Other
  - [Linux Documentations Link](doc.md)
  - [File format](fileformat.md)

---

## Usage

### Append gitignore

1. Create a directory named `certs`.
1. Append: [.gitignore](ubuntu/focal64/certs/.gitignore)

### Import your certificates files

Save your certificates files in `certs`.

### Vagrantfile shell provision

Add lines to `Vagrantfile`:

#### Ubuntu 20.04

- `path`
  - file: `update-certs.sh`
  - url: `https://raw.githubusercontent.com/rurumimic/no-check-certificate/main/ubuntu/focal64/update-certs.sh`
- 2 options: `args`
  1. `synced_folder`: `/vagrant/certs` in guest is default.
  1. certs directory's name: `my-certs` is default → Certs will save in `/usr/local/share/ca-certificates/my-certs`.

```ruby
config.vm.provision "shell" do |s|
  s.path = "https://raw.githubusercontent.com/rurumimic/no-check-certificate/main/ubuntu/focal64/update-certs.sh"
  # s.path = "update-certs.sh" 
  # s.args = ["/vagrant/certs", "my-certs"]
end
```

#### CentOS 7

- `path`
  - file: `update-certs.sh`
  - url: `https://raw.githubusercontent.com/rurumimic/no-check-certificate/main/centos/7/update-certs.sh`
- 1 option: `args`
  1. `synced_folder`: `/vagrant/certs` in guest is default.

```ruby
config.vm.provision "shell" do |s|
  s.path = "https://raw.githubusercontent.com/rurumimic/no-check-certificate/main/centos/7/update-certs.sh"
  # s.path = "update-certs.sh" 
  # s.args = ["/vagrant/certs"]
end
```

### Vagrant up

```bash
vagrant up
```

---

## Test

### CURL

```bash
curl -I https://example.com

HTTP/1.1 200 OK
```

### Ubuntu Snap

```bash
sudo snap install hello-world
hello-world

Hello World!
```

---

## Manual

Location of your `.crt` files:

```bash
SOURCE_DIR=/path/to/dir
# In this project:
# SOURCE_DIR=/vagrant/certs
```

### Ubuntu 20.04

Update CA certificates:

```bash
sudo mkdir /usr/local/share/ca-certificates/my-certs
sudo cp ${SOURCE_DIR}/*.crt /usr/local/share/ca-certificates/my-certs
sudo update-ca-certificates
```

Output:

```bash
Updating certificates in /etc/ssl/certs...
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
```

Verify:

```bash
diff --unchanged-group-format='@@ %dn,%df 
  %<' --old-group-format='' --new-group-format='' --changed-group-format='' \
  /etc/ssl/certs/ca-certificates.crt ${SOURCE_DIR}/*.crt
```

Output:

```bash
@@ 21,3503 
-----BEGIN CERTIFICATE-----
# ...
-----END CERTIFICATE-----
```

#### Snap

Store certificates in Snapd’s trusted certificates pool:

```bash
sudo snap set system store-certs.cert0="$(sed -e 's/\r//g' ${SOURCE_DIR}/YOUR_CERT_1.crt)"
sudo snap set system store-certs.cert1="$(sed -e 's/\r//g' ${SOURCE_DIR}/YOUR_CERT_2.crt)"
```

### CentOS 7

Update CA certificates:

```bash
sudo cp ${SOURCE_DIR}/*.crt /usr/share/pki/ca-trust-source/anchors
sudo update-ca-trust
```

Verify:

```bash
trust list | tail -7
```

Output:

```bash
pkcs11:id=%aa%94%60%f8%11%e1%bb;type=cert
    type: certificate
    label: COMPANY
    trust: anchor
    category: authority
```
