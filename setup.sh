#!/bin/sh

unpack_if_present() {
  _base=${1%.tar.[gbx]z*}
  if test -f "$1"; then
    rm -rf "$_base"
    tar xf "$1"
    if test -n "$2"; then
      test -d "$2" && rm -rf "$2"
      mv "$_base" "$2"
    fi
  fi
}

unzip_if_present() {
  _base=${1%.zip}
  if test -f "$1"; then
    rm -rf "$_base"
    unzip "$1"
    if test -n "$2"; then
      test -d "$2" && rm -rf "$2"
      mv "$_base" "$2"
    fi
  fi
}

unpack_if_present gcc.tar.xz
unpack_if_present clang.tar.bz2
unpack_if_present sccache.tar.bz2

unzip_if_present LLVM-*-win32.zip LLVM

unpack_if_present rust-*.tar.gz rustc
