# how to build image for hl101: #

**git clone:**
```bash
git clone https://github.com/soap-bubble-coin/buildsystem-hd2
```
**cd:**
```bash
cd buildsystem-hd2
```
**for first use:**
```bash
sudo ./prepare-for-bs.sh
```
**machine configuration - 29) HL101:**
```bash
make init
```
**build image:**
```bash
make flashimage
```

**for more details:**
```bash
make help
```

**supported boards:**
```bash
make print-boards
```
