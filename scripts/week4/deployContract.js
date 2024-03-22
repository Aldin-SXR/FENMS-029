const { ethers } = require("hardhat");

async function main() {
  
  const ElectiveCoursesIBU = await ethers.getContractFactory("ElectiveCoursesIBU");
  console.log("Deploying ElectiveCoursesIBU...");
  const contract = await ElectiveCoursesIBU.deploy();
  await contract.waitForDeployment();

  console.log("ElectiveCoursesIBU address: ", contract.target);
}

main().then(() => process.exit(0))
  .catch((error) => {
  console.error(error);
  process.exitCode = 1;
});