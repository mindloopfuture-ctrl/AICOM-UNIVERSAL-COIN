// Example Hardhat script to deploy AICOM on BSC
async function main() {
  const AICOM = await ethers.getContractFactory("AICOMUniversalToken_BSC");
  const aicom = await AICOM.deploy();
  await aicom.deployed();
  console.log("AICOM deployed to:", aicom.address);
}
main().catch((e) => { console.error(e); process.exit(1); });
