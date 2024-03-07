# macOS Dev Image

The personal image I use for self-hosted git runners. Available images:
## sonoma-m1
- Xcode 15.2 + All Runtimes
- Theos installed to ~/Library/theos
- Brew with everything required to build large projects such as Swift and llvm
- XCPretty, Cocoapods and Bundler

## sonoma-m1-unity
- Brew and lots of recommended packages
- Unity 2022.3.2f1 with Mac and Windows build support

# DIY
Change `sonoma-m1` to the iamge you prefer.

To build a local image:
```bash
packer init templates/sonoma-m1.pkr.hcl
packer build templates/sonoma-m1.pkr.hcl
```

To clone:
```bash
tart clone ghcr.io/elihwyma/sonoma-m1:14.3
```
