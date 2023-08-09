#!/usr/bin/env bash

if [[ -z "$ZOPEN_INSTALL_DIR" ]]; then
    echo "Must have env var ZOPEN_INSTALL_DIR" 1>&2
    echo "export ZOPEN_INSTALL_DIR=/xxx/yyy/zzz/zopen/prod" 1>&2
    exit 1
fi

export CC="ibm-clang64"
export CXX="ibm-clang++64"

# standard CFLAGS/CXXFLAGS used in Python SDK and Python AI Toolkit

export CFLAGS=\
"-DNDEBUG -march=arch10 -O3 -std=c11 -m64 -D_XOPEN_SOURCE=600 "\
"-D_UNIX03_THREADS -D_POSIX_THREADS -D_OPEN_SYS_FILE_EXT -m64 -fasm "\
"-fvisibility=default -fzos-le-char-mode=ascii -fno-short-enums "\

export CXXFLAGS=\
"-DNDEBUG -march=arch10 -O3 -m64 -D_XOPEN_SOURCE=600 "\
"-D_UNIX03_THREADS -D_POSIX_THREADS -D_OPEN_SYS_FILE_EXT -m64 -fasm "\
"-fvisibility=default -fzos-le-char-mode=ascii -fno-short-enums "\

# ZOSLIB_OVERRIDE_CLIB=1 to enable zoslib's std functions override
# (for some reasons target=zosv2r5 fails CMAKE_HAVE_LIBC_PTHREAD check)
export EXTRA_FLAGS=" -DZOSLIB_OVERRIDE_CLIB=1 -mzos-target=zosv2r4 \
-I$ZOPEN_INSTALL_DIR/zoslib/include "

export CFLAGS=$CFLAGS" "$EXTRA_FLAGS
export CXXFLAGS=$CXXFLAGS" "$EXTRA_FLAGS

export LDFLAGS="\
$ZOPEN_INSTALL_DIR/zoslib/lib/libzoslib.a \
$ZOPEN_INSTALL_DIR/zoslib/lib/libzoslib-supp.a"

rm -fr build
mkdir build
cd build

cmake ../cmake -DCMAKE_C_FLAGS="$CFLAGS" -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
-Dprotobuf_BUILD_SHARED_LIBS=OFF -Dprotobuf_BUILD_TESTS=OFF \
-DZLIB_INCLUDE_DIR="$ZOPEN_INSTALL_DIR/zlib/include" \
-DZLIB_LIBRARY="$ZOPEN_INSTALL_DIR/zlib/lib/libz.a" \
-DCMAKE_BUILD_TYPE=Release

cmake --build .
