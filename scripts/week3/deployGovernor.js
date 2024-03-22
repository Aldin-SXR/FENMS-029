async function main() {
    const DAOClubGovernor = await ethers.getContractFactory("DAOClubGovernor");
    console.log("Deploying DAOClubGovernor...");
  
    const VOTE_TOKEN_ADDRESS = '0xadc2A785d35f4f27E95BB838f727E24857b41219'
    const TIMELOCK_ADDRESS = '0x0f15aB90459722A93B802FFFc160CD1c3B6E69a4'
    const QUORUM_PERCENTAGE = 4 // minimum 4% tokens have to participate
    const VOTING_DELAY = 1 // wait 1 block
    const VOTING_PERIOD = 30 // voting open for 30 blocks

    const governor = await DAOClubGovernor.deploy(VOTE_TOKEN_ADDRESS, TIMELOCK_ADDRESS)
    await governor.waitForDeployment();
 
    console.log("DAOClubGovernor address:", governor.target);
 }
  
 main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
 