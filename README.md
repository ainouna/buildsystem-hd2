# how to build image NeutrinoHD2 (mohousch) for hl101: #

**git clone:**
```bash
git clone https://github.com/Greder/buildsystem-hd2.git
```
**cd:**
```bash
cd buildsystem-hd2
```
**for first use:**
```bash
sudo ./prepare-for-bs.sh
```
**machine configuration only HL101:**
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
