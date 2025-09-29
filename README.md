# E-Sign DApp - Decentralized Digital Document Signing System
## Project Overview
This project is a simple decentralized application (DApp) that allows users to:

+ compute the hash of an electronic document (e.g., PDF, Word),

+ register that hash on the Ethereum blockchain as proof of authenticity,

+ digitally sign the document using their crypto wallet (MetaMask),

+ verify who has signed the document and whether it has been registered.

_Idea_: Instead of storing the full document on-chain (which is expensive and inefficient), the DApp stores the SHA-256 hash. This provides cryptographic proof that the document existed at a specific time and was signed by a specific person, without revealing its contents.

## Technologies Used

+ Solidity — smart contract

+ Hardhat — development and testing framework

+ React.js + Vite — frontend interface

+ ethers.js — communication between frontend and blockchain

+ Crypto-JS — SHA-256 hashing

+ MetaMask — wallet integration and digital signing

## Frontend – React Application

Go to the frontend folder:

cd e-sign-frontend
npm install
npm run dev

Open the application in your browser:
http://localhost:5173 (http://localhost:5174)

## Features

_Document Registration_
+ The file is hashed locally (SHA-256) and the hash is stored on-chain.
+ Emits DocumentRegistered event.

## Digital Signing
+ The user signs the document hash with their private key via MetaMask.
+ The signature and timestamp are saved on-chain.
+ Emits DocumentSigned event.

## Verification & Signer Lookup
+ Check if a document is registered.
+ Retrieve the list of all signers for a document.

## Author: Marijana Jeremić
+ Faculty of Engineering, Kragujevac, Serbia RS — Blockchain and Cryptography Project
+ September, 2025
