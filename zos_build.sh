#!/usr/bin/env bash

if [[ -z "$ZOPEN_ROOTFS" ]]; then
    echo "Please source /usr/local/zopen/etc/zopen-config first" 1>&2
    exit 1
fi

if [[ -z "$MY_ZOPEN_ROOTFS" ]]; then
    echo "Please set MY_ZOPEN_ROOTFS" 1>&2
    echo "e.g., export MY_ZOPEN_ROOTFS=$HOME/zopen" 1>&2
    exit 1
fi

export CC="ibm-clang64"
export CXX="ibm-clang++64"

# similar CFLAGS/CXXFLAGS used in Python SDK and Python AI Toolkit
# ***** ibm-clang crahses compiling generated_message_tctable_lite.cc with -O3

export CXXFLAGS=\
"-DNDEBUG -march=arch10 -O2 -m64 -D_XOPEN_SOURCE=600 "\
"-D_UNIX03_THREADS -D_POSIX_THREADS -D_OPEN_SYS_FILE_EXT -m64 -fasm "\
"-fvisibility=default -fzos-le-char-mode=ascii -fno-short-enums "\

export CFLAGS="-std=c11 "$CXXFLAGS

# ZOSLIB_OVERRIDE_CLIB=1 to enable zoslib's std functions override
# (for some reasons target=zosv2r5 fails CMAKE_HAVE_LIBC_PTHREAD check)
export EXTRA_FLAGS=" -DZOSLIB_OVERRIDE_CLIB=1 -mzos-target=zosv2r4 \
-I$ZOPEN_ROOTFS/usr/local/include "

export CFLAGS=$CFLAGS" "$EXTRA_FLAGS
export CXXFLAGS=$CXXFLAGS" "$EXTRA_FLAGS

export LDFLAGS="\
$ZOPEN_ROOTFS/usr/local/lib/libzoslib.a \
$ZOPEN_ROOTFS/usr/local/lib/libzoslib-supp.a"

rm -fr build
mkdir build
cd build

# ***** ibm-clang crahses compiling generated_message_tctable_lite.cc with -O3
# ***** "-DCMAKE_BUILD_TYPE=Release" adds "-O3 -DNDEBUG", so can't use that either
cmake .. -DCMAKE_C_FLAGS="$CFLAGS" -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
-Dprotobuf_BUILD_SHARED_LIBS=OFF -Dprotobuf_BUILD_TESTS=OFF \
-DZLIB_INCLUDE_DIR="$MY_ZOPEN_ROOTFS/usr/local/include" \
-DZLIB_LIBRARY="$MY_ZOPEN_ROOTFS/usr/local/lib/libz.a"

cmake --build .