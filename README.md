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

# Example

The installation script provides the option to generate five random files in a folder called `file`, which you can use to test your setup.

Run `./submarine.sh file` to publish the folder but not the files. Then visit the link that is displayed to see the folder and the list of files. Click on `0.json` and the browser will hang, because the file is not published.

Then run `./reveal.sh file/0.json` and shortly afterwards the browser will display the contents of the file (a short random string of digits).

# Known limitations

The system only supports folders containing up to 5697 files. See [issue 2](https://github.com/kf106/ipfs-submarine/issues/2) for details.
