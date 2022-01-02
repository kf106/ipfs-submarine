# IPFS Submarine
**Summary:** Bash scripts with commands to submarine folders and files on Ubuntu 20.04.

The following repository contains helper scripts to allow you to submarine folders and files.

_Submarining_ is the process of obtaining and publishing an IPFS folder without publishing the files contained within the folder. This is useful for, for example, an NFT project using the OpenZeppelin ERC721 contract, where images are enumerated using:

`ifps://<folder CID>/<token ID>`

and the contract deployer only wants to reveal the underlying images over time, rather than all at once.

Some IPFS gateway companies offer this as a paid service, but the following project allows anyone to do this for free.

For more information and a walk-through of how this works, see [my article on LinkedIn](https://www.linkedin.com/pulse/how-submarine-nfts-using-ipfs-keir-finlow-bates/).

# Overview
The scripts set up two instances of the IPFS, one which is kept private, and one which is a public gateway out to the rest of the IPFS. The image folder is added and pinned in the private IPFS swarm, and then commands are avaialbe for copying parts but not all of the files underlying a folder to the public gateway.

# To use
Run the IPFS setup script:
`./install.sh`

This will set up a private IPFS instance which is not running as a background process, but can still be used by the other scripts to submarine and reveal files. It also starts a public IPFS server, the control panel of which is found at [http://127.0.0.1/5001](http://127.0.0.1/5001).

To submarine a particular folder, run:
`./submarine.sh <folder>`

To reveal a particular file from the folder, run:
`./reveal.sh <folder>/<file>`
