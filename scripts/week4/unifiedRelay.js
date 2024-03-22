async function main() {
    /**
     * GENERATE THE META TRANSACTION
     */
    console.log("Generating the meta transaction...")

    // student address
    let studentAddress = "0xa64E3108B02dbf0F087ce33d0416B5F00ac84882"
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

    /**
     * SIGN THE META TRANSACTION
     */
    console.log("Signing the meta transaction...")

    // Address of the elective course contract (or any other contract that we want to execute operations on)
    const CONTRACT_ADDRESS = '0x32f7188aeD6DF05BA7B9b95FaA483D8b39877c08';

    // Nonce (prevents transaction replays)
    // Will need to +1 for every next transaction by this user
    const NONCE = 0;

    // Encode the relay transaction
    const abiCoder = new ethers.AbiCoder();
    let rawData = abiCoder.encode(
        ["address", "bytes", "uint256"],
        [CONTRACT_ADDRESS, fnParams, NONCE]
    )

    // Hash the data
    let hash = ethers.solidityPackedKeccak256(["bytes"], [rawData])

    const provider = new ethers.AlchemyProvider(network = "sepolia", process.env.ALCHEMY_API_KEY);
    const signer = new ethers.Wallet(process.env.SEPOLIA_PRIVATE_KEY2, provider);

    let signature = await signer.signMessage(ethers.getBytes(hash))
    console.log("Signature:", signature)

    /**
     * RELAY THE META TRANSACTION
     */
    console.log("Relaying the meta transaction...")
    const RELAY_ADDRESS = '0xfb70a2eca6d70b03de4bc4c2a8715d01d6bb3d24'

    const relay = await ethers.getContractAt("Relay", RELAY_ADDRESS);

    // Whitelist if necessary
    const isWhitelisted = await relay.isInWhitelist(studentAddress);
    if (!isWhitelisted) {
        console.log("Whitelisting the address...");
        await relay.addToWhitelist(studentAddress);
    }

    const relayTx = await relay.forward(CONTRACT_ADDRESS, fnParams, NONCE, signature)
    await relayTx.wait()

    console.log("Transaction successfully relayed.");
    console.log("Transaction hash:", relayTx.hash)
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });