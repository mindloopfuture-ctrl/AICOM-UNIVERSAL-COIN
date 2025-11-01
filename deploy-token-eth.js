// Deploy script for AICOM Universal Coin on Ethereum
const hre = require("hardhat");
async function main() {
  console.log("🚀 Deploying AICOM Universal Token to Ethereum...");
  const Token = await hre.ethers.getContractFactory("AICOMUniversalTokenETH");
  const token = await Token.deploy();
  await token.waitForDeployment();
  console.log("✅ Deployed at:", await token.getAddress());
}
main().catch((e)=>{console.error(e);process.exit(1);});
