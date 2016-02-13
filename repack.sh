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
  keybase verify $1.asc
}

verify ${IDX}
for pkg in $(cat ${IDX} | grep 'tar\.gz$'); do
  verify ${pkg}
  _base=${pkg%.tar.gz}
  case ${pkg} in
    *-apple-darwin*|*-msvc*)
      _target=rustc-${_base#rust-}.tar.bz2
      tarflag=j
      ;;
    *)
      _target=rustc-${_base#rust-}.tar.xz
      tarflag=J
  esac
  rm -rf ${_base}
  echo "unpacking ${pkg}"
  tar xf ${pkg}
  cd ${_base}
  echo "repacking ${_base}/rustc as ${_target}"
  tar c${tarflag}f ../${_target} rustc/*
  rm -rf ${_base}
  cd ..
  ${TOOLTOOL} add --visibility=public --unpack ${_target}
done
