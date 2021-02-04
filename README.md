# no-check-certificate

SELF SIGNED 인증서 설정 방법

- [ ] ubuntu
- [ ] centos
- [ ] wget
- [ ] ...

## HOW TO

- ubuntu focal 20.04
  - man: [update-ca-certificates](http://manpages.ubuntu.com/manpages/focal/man8/update-ca-certificates.8.html) - update `/etc/ssl/certs` and ca-certificates.crt
  - package: [ca-certificates](https://packages.ubuntu.com/focal/ca-certificates)
    - [change logs](https://launchpad.net/ubuntu/+source/ca-certificates/+changelog)

```bash
sudo apt update
sudo apt install -y ca-certificates
```

```bash
sudo mkdir /usr/share/ca-certificates/self-signed
sudo cp /share/*.crt /usr/share/ca-certificates/self-signed
sudo update-ca-certificates -v
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
