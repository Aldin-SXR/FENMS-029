const { ethers } = require("hardhat");

async function main() {
  const [owner]= await ethers.getSigners();
  
  const DAOClubTreasury = await ethers.getContractFactory("DAOClubTreasury");
  console.log("Deploying DAOClubTreasury...");
  const treasury = await DAOClubTreasury.deploy([], { from: owner });
  await treasury.waitForDeployment();

  console.log("DAOClubTreasury address: ", bank.target);
}

main().then(() => process.exit(0))
  .catch((error) => {
  console.error(error);
  process.exitCode = 1;
});