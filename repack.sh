#!/bin/sh

# Repack just the rustc subtree from rust releases
# and add them to the manifest.

IDX=channel-rust-stable
TOOLTOOL="python ../build-tooltool/tooltool.py"

verify() {
  echo "checking $1 ..."
  shasum -c $1.sha256
  shasum -c $1.asc.sha256
  gpg --verify $1.asc
}

strip_trailing_whitespace() {
  echo "cleaning $1 ..."
  cat $1 | sed -e 's/\w*$//' > $1+ && mv $1+ $1
}

verify ${IDX}
for pkg in $(cat ${IDX} | grep 'tar\.gz$'); do
  verify ${pkg}
  _base=${pkg%.tar.gz}
  _target=rustc-${_base#rust-}.tar.xz
  rm -rf ${_base}
  echo "unpacking ${pkg}"
  tar xf ${pkg}
  cd ${_base}
  echo "repacking ${_base}/rustc as ${_target}"
  tar cJf ../${_target} rustc/*
  rm -rf ${_base}
  cd ..
  ${TOOLTOOL} add --visibility=public ${_target}
done
strip_trailing_whitespace manifest.tt
