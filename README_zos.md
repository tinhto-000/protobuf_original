# How to compile

The following packages have been modified for z/OS:

1. protobuf (this repo)
2. abseil-cpp
3. googletest

This document assumes you have access to 2 different zopen installations:

- Shared (e.g., `/usr/local/zopen/`) (i.e., some place that you do not have
  permisssion to install packages to)
  - Enviroment variable `ZOPEN_ROOTFS` points to this
  - Already contains standard/popular packages such as `git`, `make`, `cmake`,
    `zoslib`
- Local (e.g., `$HOME/zopen/`) (some place that you have complete control of)
  - Enviroment variable `MY_ZOPEN_ROOTFS` points to this
  - You might need this so that you can install `zlib` and `cmake` version
    **3.24.x**
  - Instruction: <https://zosopentools.github.io/meta/#/Guides/QuickStart>
  - You **MUST** use`cmake` v3.24.x, otherwise you'd get errors like this during
    link:

```
ar: FSUM9942 "CMakeFiles/libprotoc.dir/src/google/protobuf/compiler/python/helpers.cc.o" ignored, same basename as "CMakeFiles/libprotoc.dir/src/google/protobuf/compiler/cpp/helpers.cc.o".
```

Also the z/OS system must have "Open XL C/C++ for z/OS" (`ibm-clang64`,
`ibm-clang++64`) installed by the system programmer.

# Steps

1. `git clone --recursive` clone this repo and this branch. This command will
   also pull down the third-party dependencies.
2. Replace `abseil-cpp` and `googletest` in `/third_party` with:

```
git clone git@github.com:tinhto-000/abseil-cpp.git -b 20230125.3_zos
git clone git@github.com:tinhto-000/googletest.git -b v1.12.1_zos
```

3. source `zopen-config` from the shared zopen location (e.g.
   `source /usr/local/zopen/etc/zopen-config`) so that `ZOPEN_ROOTFS` is set.
4. `export MY_ZOPEN_ROOTFS` to where **YOUR** zopen installation is (so that it
   can find `zlib`)
5. `export PATH` to where `cmake` **v3.24.x** `bin` dir is (e.g.,
   `export PATH=$HOME/CMake-heads.v3.24.2/bin:$PATH`)
6. issue `zos_build.sh`

`protoc` and static libraries are generated at `./build`
