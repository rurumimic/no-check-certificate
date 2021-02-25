# no-check-certificate

SELF SIGNED 인증서 설정 방법

- [x] ubuntu
- [x] centos
- [ ] wget
- [ ] ...

---

## How to

### .gitignore

1. Create a directory named `certs`.
1. Add [.gitignore](ubuntu/focal64/certs/.gitignore).

### Import your certificates files

Save your certificates files in `certs`.

### Vagrantfile shell provision

Add lines to `Vagrantfile`:

#### Ubuntu

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

#### CentOS

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

## Manual

### .gitignore

1. Create a directory named `certs`.
1. Add [.gitignore](ubuntu/focal64/certs/.gitignore).

### Ubuntu: Update CA certificates

```bash
sudo mkdir /usr/local/share/ca-certificates/my-certs
sudo cp /vagrant/certs/*.crt /usr/local/share/ca-certificates/my-certs
sudo update-ca-certificates -v
```

#### Ubuntu: Verify

```bash
diff --unchanged-group-format='@@ %dn,%df 
  %<' --old-group-format='' --new-group-format='' --changed-group-format='' \
  /etc/ssl/certs/ca-certificates.crt /certs/<your-certs>.crt
```

### CentOS: Update CA certificates

```bash
sudo cp /vagrant/certs/*.crt /usr/share/pki/ca-trust-source/anchors
sudo update-ca-trust
```

#### CentOS: Verify

```bash
trust list
```

---

## Linux

### Ubuntu Focal 20.04

- man: [update-ca-certificates](http://manpages.ubuntu.com/manpages/focal/man8/update-ca-certificates.8.html) - update `/etc/ssl/certs` and ca-certificates.crt
- package: [ca-certificates](https://packages.ubuntu.com/focal/ca-certificates)
  - [change logs](https://launchpad.net/ubuntu/+source/ca-certificates/+changelog)

### CentOS 7

- RedHat: [Using Shared System Certificates](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-shared-system-certificates)
- `/etc/pki/ca-trust/`
  - `/etc/pki/ca-trust/source/anchors/`
- `/usr/share/pki/ca-trust-source/`
  - `/usr/share/pki/ca-trust-source/anchors/`
- Run: `update-ca-trust`

---

## Test

### Ubuntu

### CentOS

```bash
# Root
sudo su

# Add a Repo
cat << EOF > /etc/yum.repos.d/nginx.repo
[nginx]
name=Nginx Repository \$basearch - Archive
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
enabled=1
gpgcheck=1
gpgkey=https://nginx.org/keys/nginx_signing.key
EOF

yum install -y nginx # Install Nginx
```

#### Fail

```bash
Is this ok [y/d/N]: y

Downloading packages:
warning: /var/cache/yum/x86_64/7/nginx/packages/nginx-1.18.0-2.el7.ngx.x86_64.rpm: Header V4 RSA/SHA1 Signature, key ID 7bd9bf62: NOKEY
Public key for nginx-1.18.0-2.el7.ngx.x86_64.rpm is not installed
nginx-1.18.0-2.el7.ngx.x86_64.rpm                                                                     | 769 kB  00:00:02     
Retrieving key from https://nginx.org/keys/nginx_signing.key

GPG key retrieval failed: [Errno 14] curl#60 - "Peer's certificate issuer has been marked as not trusted by the user."
```

#### Success

```bash
nginx # Start Nginx

curl localhost # Test
```

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Welcome to nginx!</title>
```

---

## 인증서 파일 포맷 종류

- [ ] ASN.1
- [ ] BER
- [ ] CER
- [ ] DER
- [ ] PEM
- [ ] CRT
- [ ] KEY
- [ ] PFX
- [ ] P12
- [ ] CSR
- [ ] JKS

### X.690

- Wiki: [X.690](https://en.wikipedia.org/wiki/X.690)

국제전기통신연합 전기통신표준화부문 [ITU-T](https://en.wikipedia.org/wiki/ITU-T)에서 만들었다. X.509, Y.3172, H.264/MPEG-4 AVC 등등.

#### [ASN.1](https://en.wikipedia.org/wiki/ASN.1) 인코딩 포맷

Abstract Syntax Notation One: 추상 구문 표기법 1

#### 종류

- Basic Encoding Rules (BER)
- Canonical Encoding Rules (CER)
- Distinguished Encoding Rules (DER)

### BER: Basic Encoding Rules

### PEM: Privacy Enhanced Mail
