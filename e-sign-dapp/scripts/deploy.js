// scripts/deploy.js
const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  // 1) Deploy
  const Factory = await hre.ethers.getContractFactory("DocumentSigner");
  const contract = await Factory.deploy();
  await contract.waitForDeployment();

  const address = await contract.getAddress();
  console.log("✅ Contract deployed to:", address);

  // 2) Snimi address+abi u contract-info.json
  const artifact = await hre.artifacts.readArtifact("DocumentSigner");
  const out = { address, abi: artifact.abi };
  const outPath = path.join(__dirname, "..", "contract-info.json");
  fs.writeFileSync(outPath, JSON.stringify(out, null, 2));
  console.log("💾 Wrote", outPath);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});

