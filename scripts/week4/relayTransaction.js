async function main() {
    console.log("Accessing the relay...");

    // Your relay address
    const RELAY_ADDRESS = '0xfb70a2eca6d70b03de4bc4c2a8715d01d6bb3d24'

    // Raw meta transaction data
    // (supply your own calldata)
    const CALLDATA = '0x6838841b00000000000000000000000036a05dc2c816c16dcfb97ed9636c37d8b80c6ffa000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003';

    // Address of the elective course contract (or any other contract that we want to execute operations on)
    const CONTRACT_ADDRESS = '0x32f7188aed6df05ba7b9b95faa483d8b39877c08';

    // Nonce (prevents transaction replays)
    // Will need to +1 for every next transaction by this user
    const NONCE = 0;

    // Meta transaction signature (supply the signature)
    const SIGNATURE = '0x376a1f326530b67c91e4108b6884cdc0940bf37610d6f8a1ac077e96551cdd9d0a0db701aa3a14ca1c1a21e78e969ff65c82980ee89e4dafc140a23551984b9a1c'

    const relay = await ethers.getContractAt("Relay", RELAY_ADDRESS);

    const relayTx = await relay.forward(CONTRACT_ADDRESS, CALLDATA, NONCE, SIGNATURE)
    await relayTx.wait()

    console.log("Transaction successfully relayed.");
    console.log(relayTx)
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });