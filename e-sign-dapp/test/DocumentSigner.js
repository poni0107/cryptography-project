const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DocumentSigner", function () {
  it("register + sign", async () => {
    const [a, b] = await ethers.getSigners();
    const F = await ethers.getContractFactory("DocumentSigner");
    const c = await F.deploy();

    const docHash = ethers.keccak256(ethers.toUtf8Bytes("spec"));
    await expect(c.registerDocument(docHash)).to.emit(c, "DocumentRegistered");

    // potpis off-chain pa on-chain
    const sig = await a.signMessage(ethers.getBytes(docHash));
    await expect(c.addSignature(docHash, sig)).to.emit(c, "DocumentSigned");

    // drugi korisnik
    const sig2 = await b.signMessage(ethers.getBytes(docHash));
    await expect(c.connect(b).addSignature(docHash, sig2)).to.emit(c, "DocumentSigned");
  });

  it("rejects double register and double sign", async () => {
    const [a] = await ethers.getSigners();
    const F = await ethers.getContractFactory("DocumentSigner");
    const c = await F.deploy();

    const h = ethers.keccak256(ethers.toUtf8Bytes("same"));
    await c.registerDocument(h);
    await expect(c.registerDocument(h)).to.be.reverted; // AlreadyRegistered

    const sig = await a.signMessage(ethers.getBytes(h));
    await c.addSignature(h, sig);
    await expect(c.addSignature(h, sig)).to.be.reverted; // AlreadySigned
  });
});
