#!/bin/sh

cd work/kernel
cd $(ls -d *)
WORK_KERNEL_DIR=$(pwd)
cd ../../..

cd work/musl

# Change to the first directory ls finds, e.g. 'musl-1.1.11'
cd $(ls -d *)

cd musl-installed/bin

unlink musl-ar 2>/dev/null
ln -s `which ar` musl-ar

unlink musl-strip 2>/dev/null
ln -s `which strip` musl-strip

cd ../include

# Copy all kernel headers to musl's 'include' folder
cp -rf $WORK_KERNEL_DIR/usr/include/* .

# Make sure some C structs are not defined in kernel headers if thgey are already defined in musl
sed -i "s/^\#if.__UAPI_DEF_IN6_ADDR$/#if !defined(_NETINET_IN_H) \&\& defined(__UAPI_DEF_IN6_ADDR)/" ./linux/in6.h
sed -i "s/^\#if.__UAPI_DEF_SOCKADDR_IN6$/#if !defined(_NETINET_IN_H) \&\& defined(__UAPI_DEF_SOCKADDR_IN6)/" ./linux/in6.h
sed -i "s/^\#if.__UAPI_DEF_IPV6_MREQ$/#if !defined(_NETINET_IN_H) \&\& defined(__UAPI_DEF_IPV6_MREQ)/" ./linux/in6.h

