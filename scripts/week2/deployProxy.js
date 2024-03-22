async function main() {
    const SimpleBank = await ethers.getContractFactory("SimpleBank");
    console.log("Deploying SimpleBank...");
    const bank = await upgrades.deployProxy(SimpleBank, [], {
        initializer: false, // if exists, give the intializer function name
    });
    await bank.waitForDeployment();

    console.log("SimpleBank (proxy contract): ", bank.target);
    console.log(
        "SimpleBank (logic contract): ",
        await upgrades.erc1967.getImplementationAddress(bank.target)
    );
    console.log(
        "SimpleBank (proxy admin contract): ",
        await upgrades.erc1967.getAdminAddress(bank.target)
    );
}

main().then(() => process.exit(0))
    .catch((error) => {
    console.error(error);
    process.exitCode = 1;
});