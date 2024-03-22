async function main() {
    const SimpleBank = await ethers.getContractFactory("SimpleBankUUPS");
    console.log("Deploying SimpleBankUUPS...");
    const bank = await upgrades.deployProxy(SimpleBank, [], {
        initializer: 'initialize',
    });
    await bank.waitForDeployment();

    console.log("SimpleBank (proxy contract): ", bank.target);
    console.log(
        "SimpleBank (logic contract): ",
        await upgrades.erc1967.getImplementationAddress(bank.target)
    );
}

main().then(() => process.exit(0))
    .catch((error) => {
    console.error(error);
    process.exitCode = 1;
});