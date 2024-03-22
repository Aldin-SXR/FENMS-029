async function main() {
    const SimpleBank = await ethers.getContractFactory("SimpleBankUUPSV2");
    console.log("Upgrading SimpleBank...");
    const PROXY_ADDRESS = '0x1811DA1dbB5aFA9bC8D5e34920167DFE266CcbF4';
    const bank = await upgrades.upgradeProxy(PROXY_ADDRESS, SimpleBank);
    await bank.waitForDeployment();

    console.log(
        "SimpleBankUUPSV2 (logic contract): ",
        await upgrades.erc1967.getImplementationAddress(PROXY_ADDRESS)
    );
}

main().then(() => process.exit(0))
    .catch((error) => {
    console.error(error);
    process.exitCode = 1;
});