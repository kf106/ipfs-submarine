#!/usr/bin/env bash
# Copyright (c) 2022 Keir Finlow-Bates <keir@chainfrog.com>

# Make sure we have a tmp folder
if [[ ! -d ./tmp ]]
then
    mkdir tmp
fi

# First check that ipfs is installed
if which ipfs >/dev/null; then
    echo "IPFS installed"
else
    echo "Installing IPFS"
    wget https://dist.ipfs.io/go-ipfs/v0.11.0/go-ipfs_v0.11.0_linux-amd64.tar.gz
    mv go-ipfs_v0.11.0_linux-amd64.tar.gz tmp/
    cd tmp
    tar -xvzf go-ipfs_v0.11.0_linux-amd64.tar.gz
    cd go-ipfs
    sudo bash install.sh
    cd ../../
fi

if [[ -d ./ipfs-public ]]
then
    echo "There appears to have been a previous install"
    exit 1
fi

HERE=`echo "$(realpath $0)" | sed 's|\(.*\)/.*|\1|'`
mkdir ipfs-private
mkdir ipfs-public

# Set up private IPFS
IPFS_PATH=$HERE/ipfs-private ipfs init
echo -e “/key/swarm/psk/1.0.0/\n/base16/\n`tr -dc ‘a-f0-9’ < /dev/urandom | head -c64`” > ~/ipfs-private/swarm.key
IPFS_PATH=~/ipfs-private ipfs bootstrap rm --all
PEERID=`IPFS_PATH=~/ipfs-private ipfs config show | grep "PeerID" | sed 's/.*: //' | sed 's/\"//g'`
IPFS_PATH=~/ipfs-private ipfs bootstrap add "/ip4/127.0.0.1/tcp/4001/ipfs/$PEERID"
# change ports for private, just in case we run the daemon
sed -i 's|tcp/4001|tcp/4002|g' ./ipfs-private/config
sed -i 's|udp/4001|udp/4002|g' ./ipfs-private/config
sed -i 's|tcp/5001|tcp/5002|g' ./ipfs-private/config
sed -i 's|tcp/8080|tcp/8081|g' ./ipfs-private/config

# And set up public IPFS
IPFS_PATH=$HERE/ipfs-public ipfs init

# Finally, start the public IPFS daemon
IPFS_PATH=$HERE/ipfs-public ipfs daemon &

sleep 3
echo
echo "Public IPFS server running. To stop it enter 'pkill ipfs'"

read -p "Create a ./test folder with random files? (y/n) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    mkdir test
    echo $RANDOM | md5sum | head -c 20 > ./test/0.json
    echo $RANDOM | md5sum | head -c 20 > ./test/1.json
    echo $RANDOM | md5sum | head -c 20 > ./test/2.json
    echo $RANDOM | md5sum | head -c 20 > ./test/3.json
    echo $RANDOM | md5sum | head -c 20 > ./test/4.json        
fi
