How to compile
===================================================

Install `cmake`, `zoslib` and `zlib` from z/OS Open Tools:

https://zosopentools.github.io/meta/#/Guides/QuickStart

Make sure `ibm-clang64` and `ibm-clang++64` are on the system.

Then:

```
ZOPEN_INSTALL_DIR=/xxx/yyy/zzz/zopen/prod zos_build.sh
```

`protoc` and static libraries are generated at `./build`
