const { ethers } = require("hardhat");
const fs = require("fs");

async function main() {
  // 1️⃣ Učitavamo ABI i adresu ugovora
  const contractInfo = JSON.parse(fs.readFileSync("./contract-info.json"));
  const abi = contractInfo.abi;
  const address = contractInfo.address;

  // 2️⃣ Dobijamo signer iz Hardhata
  const [signer] = await ethers.getSigners();
  console.log("✍️ Potpisujemo kao:", await signer.getAddress());

  // 3️⃣ Kreiramo instancu ugovora
  const contract = new ethers.Contract(address, abi, signer);

  // ⚠️ Koristi isti hash koji si koristila za registraciju (ovde primer)
  const docHash = "0x" + "11".repeat(32);

  // 4️⃣ Off-chain potpis poruke
  const signature = await signer.signMessage(ethers.getBytes(docHash));
  console.log("📜 Potpis:", signature);

  // 5️⃣ Slanje potpisa on-chain
  const tx = await contract.addSignature(docHash, signature);
  console.log("📤 Tx poslat:", tx.hash);

  const receipt = await tx.wait();
  console.log("✅ Dokument potpisan u bloku:", receipt.blockNumber);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
