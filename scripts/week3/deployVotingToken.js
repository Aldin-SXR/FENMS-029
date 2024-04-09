const { ethers } = require("hardhat");

async function main() {
  
  const DAOClubToken = await ethers.getContractFactory("DAOClubToken");
  console.log("Deploying DAOClubToken...");
  // Ethereum uses amount * 10^18 for token amounts
  // So, 1000000000000000000000 = 1000 000000000000000000 1000 * 10^18 = 100 total tokens
  const token = await DAOClubToken.deploy("1000000000000000000000")
  await token.waitForDeployment();

  console.log("DAOClubToken address: ", token.target);
}

main().then(() => process.exit(0))
  .catch((error) => {
  console.error(error);
  process.exitCode = 1;
});