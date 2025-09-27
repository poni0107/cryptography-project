// scripts/register.js
require("dotenv").config();
const { ethers } = require("hardhat");
const fs = require("fs");

// učitavamo contract-info.json
const info = JSON.parse(fs.readFileSync("./contract-info.json", "utf8"));

async function main() {
  const provider = new ethers.JsonRpcProvider(process.env.RPC_URL_SEPOLIA);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
  console.log("✅ Koristimo nalog:", wallet.address);

  const contract = new ethers.Contract(info.address, info.abi, wallet);

  // primer dokumenta (nasumični hash za test)
  const docHash = ethers.keccak256(ethers.toUtf8Bytes("my_test_document"));
  console.log("📄 Hash dokumenta:", docHash);

  const tx = await contract.registerDocument(docHash);
  console.log("📤 Tx poslat:", tx.hash);

  const receipt = await tx.wait();
  console.log("✅ Dokument registrovan u bloku:", receipt.blockNumber);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
