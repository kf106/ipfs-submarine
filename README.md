# IPFS Submarine
**Summary:** Docker image with commands to submarine folders and files

The following repository contains the source code and dockerfile for creating a docker image that allows you to submarine folders and files.

_Submarining_ is the process of obtaining and publishing an IPFS folder without publishing the files contained within the folder. This is useful for, for example, an NFT project using the OpenZeppelin ERC721 contract, where images are enumerated using:

`ifps://<folder CID>/<token ID>`

and the contract deployer only wants to reveal the underlying images over time, rather than all at once.

Some IPFS gateway companies offer this as a paid service, but the following project allows anyone to do this for free.

# Overview
The docker image contains two instances of the IPFS, one which is kept private, and one which is a public gateway out to the rest of the IPFS. The image folder is added and pinned in the private IPFS swarm, and then commands are avaialbe for copying parts but not all of the files underlying a folder to the public gateway.
