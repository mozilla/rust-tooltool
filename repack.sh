#!/bin/sh

# Copyright (c) 2016 Mozilla Foundation.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set -e

# Download, install and repack rustc and the corresponding
# std library release builds and add them to the manifest.

IDX=channel-rustc-stable
TOOLTOOL="python ../build-tooltool/tooltool.py"

verify() {
  echo "checking $1 ..."
  shasum -c $1.sha256
  shasum -c $1.asc.sha256
  gpg --verify $1.asc
  keybase verify $1.asc
}

verify ${IDX}
for pkg in $(cat ${IDX} | grep 'rustc-.*\.tar\.gz$'); do
  verify ${pkg}
  std=rust-std-${pkg#rustc-}
  verify ${std}
  _base=${pkg%.tar.gz}
  case ${pkg} in
    *-apple-darwin*|*-msvc*)
      _target=${_base}.tar.bz2
      tarflag=j
      ;;
    *)
      _target=${_base}.tar.xz
      tarflag=J
  esac
  rm -rf rustc
  mkdir rustc

  rm -rf ${_base}
  echo "unpacking ${pkg}"
  tar xf ${pkg}
  echo "installing ${pkg}"
  ${_base}/install.sh --prefix=$PWD/rustc --disable-ldconfig
  rm -rf ${_base}

  echo "unpacking ${std}"
  _stdbase=${std%.tar.gz}
  tar xf ${std}
  echo "installing ${std}"
  ${_stdbase}/install.sh --prefix=$PWD/rustc --disable-ldconfig
  rm -rf ${_stdbase}

  echo "repacking ${_target}"
  tar c${tarflag}f ${_target} rustc/*
  rm -rf rustc

  ${TOOLTOOL} add --visibility=public --unpack ${_target}
done
