// Raw meta transaction data
const { ethers } = require("hardhat");

// (supply your own calldata)
const CALLDATA = '0x6838841b00000000000000000000000036a05dc2c816c16dcfb97ed9636c37d8b80c6ffa000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003';

// Address of the elective course contract (or any other contract that we want to execute operations on)
const CONTRACT_ADDRESS = '0x32f7188aeD6DF05BA7B9b95FaA483D8b39877c08';

// Nonce (prevents transaction replays)
// Will need to +1 for every next transaction by this user
const NONCE = 0;

// Encode the relay transaction
const abiCoder = new ethers.AbiCoder();
let rawData = abiCoder.encode(
   ["address", "bytes", "uint256"],
   [CONTRACT_ADDRESS, CALLDATA, NONCE]
)
console.log("Relay data:", rawData);

// Hash the data
let hash = ethers.solidityPackedKeccak256(["bytes"], [rawData])
console.log("Data hash:", hash)

// Sign the message
async function sign() {
   const provider = new ethers.AlchemyProvider(network = "sepolia", process.env.ALCHEMY_API_KEY);
   const signer = new ethers.Wallet(process.env.SEPOLIA_PRIVATE_KEY2, provider);
  
   let signature = await signer.signMessage(ethers.getBytes(hash))
   console.log("Signature:", signature)
}
sign();