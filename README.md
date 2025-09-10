The objective of this project is to develop a decentralized application (DApp) that allows users to digitally sign and verify electronic documents using cryptographic mechanisms and the Ethereum blockchain.

The focus is on document authenticity.
The system ensures that the hash of a document and its digital signature are recorded on the blockchain, proving that the document was signed at a specific time and by a specific user.

-Key Components-

Smart Contract:

Links a document hash with the signer and the signing timestamp.

Stores records of documents, their owners, and all signers.

Emits events when a document is registered, signed, or verified.

Supports multiple users signing the same document.

Front-End Application:

Users can upload a document, calculate its hash, sign it digitally, and verify the signature.

Provides notifications about successful registration, signing, and verification.

Web3 Integration:

Uses ethers.js or Web3.js for communication with the blockchain.

Connects via MetaMask for transaction and message signing.

Development & Testing:

Deployment and testing in Truffle or Hardhat environment.

Includes automated tests for:

Document registration.

Adding signatures.

Verifying signature validity.

Cryptographic & Security Requirements:

Document hash: SHA-256 (or another reliable hash function).

Digital signatures: ECDSA (asymmetric cryptography).

Signature verification: possible without the private key, using only publicly available data.

Every record must include a timestamp.
Technical Details

Blockchain Network: Ethereum (Sepolia Testnet)

Wallets: MetaMask accounts for signing transactions and messages

Test ETH: Obtain free Sepolia ETH from the https://cloud.google.com/application/web3/faucet/ethereum/sepolia

Deployment Options:

Truffle/Hardhat (Recommended): Full deployment with tests and automation.

Remix IDE: Simplified option (limited testing and scripts).
