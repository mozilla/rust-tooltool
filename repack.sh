#!/bin/sh

IDX=channel-rust-stable

verify() {
  echo "checking $1 ..."
  shasum -c $1.sha256
  shasum -c $1.asc.sha256
  gpg --verify $1.asc
}

verify ${IDX}
for pkg in $(cat ${IDX} | grep 'tar\.gz$'); do
  verify ${pkg}
  _base=${pkg%.tar.gz}
  _target=rustc.tar.xz
  rm -rf ${_base}
  echo "unpacking ${pkg}"
  tar xf ${pkg}
  cd ${_base}
  echo "repacking ${_base}/${_target}"
  tar cJf ${_target} rustc/*
  cd ..
done
