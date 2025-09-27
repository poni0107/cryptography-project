// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract DocumentSigner {
    using ECDSA for bytes32;

    struct SignatureInfo {
        address signer;
        uint256 signedAt;
        bytes signature;
    }

    struct Document {
        address owner;
        uint256 registeredAt;
        address[] signers;
        mapping(address => bool) hasSigned;   // brza provera duplikata
        SignatureInfo[] signatures;           // istorija potpisa
    }

    // ===== Storage =====
    mapping(bytes32 => Document) private documents;
    mapping(bytes32 => bool) private isRegistered;

    // Dodatno: eksplicitna mapa da lako čitamo vreme potpisa po (docHash, signer)
    // (može se izvući i iz signatures[], ali ovo je O(1) i ima auto-getter u ABI-ju)
    mapping(bytes32 => mapping(address => uint256)) public signedAt;

    // ===== Events =====
    event DocumentRegistered(bytes32 indexed docHash, address indexed owner, uint256 timestamp);
    event DocumentSigned(bytes32 indexed docHash, address indexed signer, uint256 timestamp);

    // ===== Errors =====
    error AlreadyRegistered(bytes32 docHash);
    error NotRegistered(bytes32 docHash);
    error AlreadySigned(bytes32 docHash, address signer);

    // ===== Core =====

    /// @notice Registruje dokument (hash) sa vlasnikom i timestampom.
    function registerDocument(bytes32 docHash) external {
        if (isRegistered[docHash]) revert AlreadyRegistered(docHash);
        Document storage d = documents[docHash];
        d.owner = msg.sender;
        d.registeredAt = block.timestamp;
        isRegistered[docHash] = true;

        emit DocumentRegistered(docHash, msg.sender, block.timestamp);
    }

    /// @notice Dodaje potpis za dokument; verifikuje ECDSA (EIP-191) i beleži vreme.
    /// @dev Potpisuje se poruka: "\x19Ethereum Signed Message:\n32" + docHash
    function addSignature(bytes32 docHash, bytes calldata signature) external {
        if (!isRegistered[docHash]) revert NotRegistered(docHash);

        // 1) Verifikacija da potpis odgovara msg.sender-u (EIP-191)
        bytes32 ethSigned = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", docHash)
        );
        address recovered = ethSigned.recover(signature);
        require(recovered == msg.sender, "Signature does not match msg.sender");

        Document storage d = documents[docHash];

        // 2) Zabrani dupli potpis istog potpisnika
        if (d.hasSigned[msg.sender]) revert AlreadySigned(docHash, msg.sender);

        // 3) Upisi potpis u stanje
        d.hasSigned[msg.sender] = true;
        d.signers.push(msg.sender);

        uint256 nowTs = block.timestamp;
        d.signatures.push(
            SignatureInfo({ signer: msg.sender, signedAt: nowTs, signature: signature })
        );

        // 4) Odrzavaj i O(1) mapu za timestamp po potpisniku
        signedAt[docHash][msg.sender] = nowTs;

        // 5) Emituj dogadjaj sa vremenom
        emit DocumentSigned(docHash, msg.sender, nowTs);
    }

    // ===== View / Query =====

    /// @notice Da li je dokument registrovan?
    function isDocumentRegistered(bytes32 docHash) external view returns (bool) {
        return isRegistered[docHash];
    }

    /// @notice Lista svih potpisnika (redosled potpisivanja).
    function getSigners(bytes32 docHash) external view returns (address[] memory) {
        if (!isRegistered[docHash]) revert NotRegistered(docHash);
        return documents[docHash].signers;
    }

    /// @notice Info o dokumentu: vlasnik, vreme registracije, broj potpisa.
    function getDocumentInfo(bytes32 docHash)
        external
        view
        returns (address owner, uint256 registeredAt, uint256 signatureCount)
    {
        if (!isRegistered[docHash]) revert NotRegistered(docHash);
        Document storage d = documents[docHash];
        return (d.owner, d.registeredAt, d.signatures.length);
    }

    /// @notice Vreme kada je određeni potpisnik potpisao dati dokument (0 ako nije).
    function getSignatureTimestamp(bytes32 docHash, address signer) external view returns (uint256) {
        if (!isRegistered[docHash]) revert NotRegistered(docHash);
        return signedAt[docHash][signer];
    }

    /// @notice Vrati sve potpise (signer[], signedAt[], signature[]) radi preglednosti na frontu.
    function getAllSignatures(bytes32 docHash)
        external
        view
        returns (address[] memory signers_, uint256[] memory times_, bytes[] memory signatures_)
    {
        if (!isRegistered[docHash]) revert NotRegistered(docHash);
        Document storage d = documents[docHash];
        uint256 n = d.signatures.length;

        signers_ = new address[](n);
        times_   = new uint256[](n);
        signatures_ = new bytes[](n);

        for (uint256 i = 0; i < n; i++) {
            SignatureInfo storage s = d.signatures[i];
            signers_[i] = s.signer;
            times_[i]   = s.signedAt;
            signatures_[i] = s.signature;
        }
    }
}


