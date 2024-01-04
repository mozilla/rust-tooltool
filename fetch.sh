#!/bin/sh

# Copyright (c) 2016 Mozilla Foundation.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set -e

URL=https://static.rust-lang.org/dist/
IDX=channel-rustc-stable

fetch() {
  echo "fetching $1 ..."
  curl -Os ${URL}${1}
  curl -Os ${URL}${1}.asc
  curl -Os ${URL}${1}.sha256
  curl -Os ${URL}${1}.asc.sha256
}

verify() {
  echo "checking $1 ..."
  shasum -c $1.sha256
  shasum -c $1.asc.sha256
  gpg --verify $1.asc
  keybase verify $1.asc
}

# grab manifest
fetch ${IDX}
for res in $(cat ${IDX} | grep ${IDX}); do
  fetch ${res}
done
verify ${IDX}

for pkg in $(cat ${IDX} | grep '\.tar\.'); do
  fetch ${pkg}
done
for pkg in $(cat ${IDX} | grep 'tar\.gz$'); do
  verify ${pkg}
done
