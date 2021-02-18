# no-check-certificate

SELF SIGNED 인증서 설정 방법

- [ ] ubuntu
- [ ] centos
- [ ] wget
- [ ] ...

## How to

### .gitignore

1. Create a directory named `certs`.
1. Add [.gitignore](ubuntu/focal64/certs/.gitignore).

### Import your certificates files

Save your certificates files in `certs`.

### Vagrantfile shell provision

Add lines to `Vagrantfile`:

- `path`
  - file: `update-certs.sh`
  - url: `https://raw.githubusercontent.com/rurumimic/no-check-certificate/main/ubuntu/focal64/update-certs.sh`
- (option) `args`
  1. `synced_folder`: `/certs` in guest is default.
  1. certs directory's name: `my-certs` is default → Certs will save in `/usr/local/share/ca-certificates/my-certs`.

```ruby
config.vm.synced_folder "./certs", "/certs"
config.vm.provision "shell" do |s|
  s.path = "https://raw.githubusercontent.com/rurumimic/no-check-certificate/main/ubuntu/focal64/update-certs.sh"
  # s.path = "update-certs.sh" 
  # s.args = ["/certs", "my-certs"]
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

### Update CA certificates

```bash
sudo mkdir /usr/local/share/ca-certificates/my-certs
sudo cp /share/*.crt /usr/local/share/ca-certificates/my-certs
sudo update-ca-certificates -v
```

### Verify

```bash
diff --unchanged-group-format='@@ %dn,%df 
  %<' --old-group-format='' --new-group-format='' --changed-group-format='' \
  /etc/ssl/certs/ca-certificates.crt /certs/<your-certs>.crt
```

---

## Linux

### Ubuntu Focal 20.04

- man: [update-ca-certificates](http://manpages.ubuntu.com/manpages/focal/man8/update-ca-certificates.8.html) - update `/etc/ssl/certs` and ca-certificates.crt
- package: [ca-certificates](https://packages.ubuntu.com/focal/ca-certificates)
  - [change logs](https://launchpad.net/ubuntu/+source/ca-certificates/+changelog)

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
