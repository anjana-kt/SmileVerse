## SmileVerse

## How to run
add dependencies : 
`yarn add ethers hardhat @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers web3modal @openzeppelin/contracts ipfs-http-client axios` 

command for starting or restarting blockchain server :
`npx hardhat node`

command to deploy in localhost : 
`npx hardhat run scripts/deploy.js --network localhost`

command to deploy in polygon testnet (also change the private key in .secret file): 
`npx hardhat run scripts/deploy.js --network mumbai`

to run : 
`npm run dev`

## Problem
Ever had that feeling when your friends take credit for your jokes and re-use them to other people just seconds after you told them? May be this can be a problem if your jokes are good enough to earn some dollars. 
1. As mentioned above the benefits of memes are tons but it will be difficult for a dedicated meme creator to generate income even though memes are a part of the Entertainment sector.
2. Moreover we lack a good social platform dedicated for memes and for such entertaining communities.
 
## What it does
SmileVerse comes up with a platform to post memes and gifs that are dedicated to bring a smile on peoples face and entertain them. Anyone using the app can vote some "smiles" to the post. A high number of smiles indicates the popularity of the meme.
The creators will be easily able to turn their popular memes into nfts by uploading it to the SmileVerse NFT marketplace using the application or in the SmileVerse website.
If the memes are mindblowing to the users and feels like rewarding them, then they could gift some SmileVerse tokens(SMILE) which will be used throughout the SmileVerse and will have some real value. These SMILE tokens can be either bought or earned from the SmileVerse.

## How we built it
SmileVerse is built using Next js framework as the very base of this Dapp. The smart contracts are based on Ethereum blockchain written in Solidity. The contracts are tested and deployed using Hardhat Ethereum development environment. It was deployed in localhost and later to Polygon Testnet.


## Authors

- **Anjana K T**  - [anjanakt](https://github.com/anjana-kt)
- **Anirudh A K** - [anirudh](https://github.com/AnirudhAK07)
