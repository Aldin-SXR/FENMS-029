const { ethers } = require("hardhat")

// student address
let studentAddress = "0x36a05Dc2C816C16DCfB97eD9636C37D8b80C6Ffa"
// Course list
let courses = [0, 1, 2, 3]

// Define the contract ABI interface
const abi = [
    "function registerCourses(address,uint256[])"
]
const interface = new ethers.Interface(abi)

// Get the function signature by hashing it and retrieving the first 4 bytes
let fnSignature = interface.getFunction("registerCourses").selector
console.log("Function signature:", fnSignature);

// Encode the function parameters and generate the calldata
let fnParams = interface.encodeFunctionData("registerCourses", [studentAddress, courses])
console.log("Calldata:", fnParams);