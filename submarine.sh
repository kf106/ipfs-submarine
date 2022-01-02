#!/usr/bin/env bash
# Copyright (c) 2022 Keir Finlow-Bates <keir@chainfrog.com>

# First check that ipfs is installed and that the folder to submarine exists
if which ipfs >/dev/null; then
    echo "IPFS installed: proceeding"
else
    echo "Run ./install.sh first"
    exit 1
fi

if [[ ! -d ./ipfs-private ]]
then
    echo "No private IPFS found - have you run ./install.sh?"
    exit 1
fi

if [[ ! -d ./ipfs-public ]]
then
    echo "No public IPFS found - have you run ./install.sh?"
    exit 1
fi

if [ -z "$1" ]
then
    echo "No folder to submarine provided."
    exit 1
fi

if [[ ! -d "$1" ]]
then
    echo "Folder $1 not found. Exiting."
    exit 1
fi

if [[ -z `ls $1` ]]
then
    echo "There are no files in $1. Exiting."
    exit 1
fi

HERE=`echo "$(realpath $0)" | sed 's|\(.*\)/.*|\1|'`

OUTPUT=`IPFS_PATH=$HERE/ipfs-private ipfs add --pin=false --recursive --cid-version=1 $1`
FOLDERCID=`echo $OUTPUT | sed 's/.*added bafy/bafy/' | sed 's/ .*//'`

IPFS_PATH=$HERE/ipfs-private ipfs block get $FOLDERCID > tmp/$FOLDERCID.bin
IPFS_PATH=$HERE/ipfs-private ipfs repo gc

cat tmp/$FOLDERCID.bin | IPFS_PATH=$HERE/ipfs-public ipfs dag put --store-codec dag-pb --input-codec dag-pb
IPFS_PATH=$HERE/ipfs-public ipfs pin add --recursive=false $FOLDERCID

echo "Your folder is now publicly pinned, but you can't see it or the files until you add them individually."
echo "http://127.0.0.1:8080/ipfs/$FOLDERCID/<file>"

