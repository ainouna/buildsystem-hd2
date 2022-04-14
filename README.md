# how to build image: #

```bash
git clone https://github.com/soap-bubble-coin/buildsystem-hd2

cd buildsystem-hd2
```

**for first use:**
```bash
sudo ./prepare-for-bs.sh
```
**machine configuration:**
```bash
$:~ make init
```
**build image:**
```bash
$:~ make flashimage
```

**for more details:**
```bash
$:~ make help
```

**supported boards:**
```bash
$:~ make print-boards
```
