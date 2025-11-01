// scripts/deploy-token-eth.js
// Deploy script for AICOM Universal Coin on Ethereum
const hre = require("hardhat");

async function main() {
  console.log("🚀 Deploying AICOM Universal Coin on Ethereum...");

  const Token = await hre.ethers.getContractFactory("AICOMUniversalToken");
  const token = await Token.deploy();

  await token.waitForDeployment();
  console.log(`✅ AICOM Universal Coin deployed at: ${await token.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
