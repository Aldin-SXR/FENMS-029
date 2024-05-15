const { ethers } = require("hardhat");

async function main() {
  
  const WeatherOracle = await ethers.getContractFactory("WeatherOracle");
  console.log("Deploying WeatherOracle...");
  const contract = await WeatherOracle.deploy(0);
  await contract.waitForDeployment();

  console.log("WeatherOracle address: ", contract.target);
}

main().then(() => process.exit(0))
  .catch((error) => {
  console.error(error);
  process.exitCode = 1;
});