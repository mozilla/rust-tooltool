#!/bin/sh

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

unzip_if_present LLVM-*-win32.zip LLVM
