async function main() {
    const Timelock = await ethers.getContractFactory("Timelock");
    console.log("Deploying Timelock...");

    const MIN_DELAY = 5; // wait for 5 blocks before executing
    const PROPOSERS = [];
    const EXECUTORS = [];
    const TIMELOCK_ADMIN = "0xeDFB674491Bb3A11c2Cd746d2e33C0254d8BC890" // your Metamask account

    const timelock = await Timelock.deploy(MIN_DELAY, PROPOSERS, EXECUTORS, TIMELOCK_ADMIN)
    await timelock.waitForDeployment();

    console.log("Timelock address:", timelock.target);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });