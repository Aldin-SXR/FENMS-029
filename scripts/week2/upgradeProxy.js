async function main() {
    const SimpleBank = await ethers.getContractFactory("SimpleBankV2");
    console.log("Upgrading SimpleBank...");
    const PROXY_ADDRESS = '0x09adAeF3CaACBF4588c69e71Dfc2D823Bd415B66';
    const bank = await upgrades.upgradeProxy(PROXY_ADDRESS, SimpleBank);
    await bank.waitForDeployment();

    console.log(
        "SimpleBankV2 (logic contract): ",
        await upgrades.erc1967.getImplementationAddress(PROXY_ADDRESS)
    );
}

main().then(() => process.exit(0))
    .catch((error) => {
    console.error(error);
    process.exitCode = 1;
});