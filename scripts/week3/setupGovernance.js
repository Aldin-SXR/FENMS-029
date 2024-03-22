async function main() {
    console.log("Setting up governance...");
 
    const METAMASK_ADDRESS = '0xeDFB674491Bb3A11c2Cd746d2e33C0254d8BC890' // your address
    const TIMELOCK_ADDRESS = '0x0f15ab90459722a93b802fffc160cd1c3b6e69a4'
    const GOVERNOR_ADDRESS = '0x08ba8Db26389D8EAA14f199cdeb148F449EFb603'
 
    const timelock = await ethers.getContractAt("Timelock", TIMELOCK_ADDRESS);
 
    const proposerRole = await timelock.PROPOSER_ROLE()
    const executorRole = await timelock.EXECUTOR_ROLE()
    // const adminRole = await timelock.TIMELOCK_ADMIN_ROLE()
 
    const proposerTx = await timelock.grantRole(proposerRole, GOVERNOR_ADDRESS)
    await proposerTx.wait()
 
    const executorTx = await timelock.grantRole(executorRole, GOVERNOR_ADDRESS)
    await executorTx.wait()
 
    // Remove the temporary admin
   // const revokeTx = await timelock.revokeRole(adminRole, METAMASK_ADDRESS)
  //  await revokeTx.wait()
 
    console.log("Proposer and executor roles set up.");
 }
 
 main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });