#!/bin/sh

rm -rf gcc
tar -Jxf gcc.tar.xz
rm -rf sccache
tar -jxf sccache.tar.bz2
rm -rf rustc
tar xf rust-1.0.0-x86_64-unknown-linux-gnu.tar.gz --strip-components=1
