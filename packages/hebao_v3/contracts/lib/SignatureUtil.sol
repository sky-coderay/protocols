// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright 2017 Loopring Technology Limited.
pragma solidity ^0.8.17;

import "../thirdparty/BytesUtil.sol";
import "./AddressUtil.sol";
import "./ERC1271.sol";

/// @title SignatureUtil
/// @author Daniel Wang - <daniel@loopring.org>
/// @dev This method supports multihash standard. Each signature's last byte indicates
///      the signature's type.
library SignatureUtil {
    using BytesUtil for bytes;
    using AddressUtil for address;

    enum SignatureType {
        ILLEGAL,
        INVALID,
        EIP_712,
        ETH_SIGN,
        WALLET // deprecated
    }

    bytes4 internal constant ERC1271_MAGICVALUE = 0x1626ba7e;

    function verifySignatures(
        bytes32 signHash,
        address[] memory signers,
        bytes[] memory signatures
    ) internal view returns (bool) {
        require(signers.length == signatures.length, "BAD_SIGNATURE_DATA");
        address lastSigner;
        for (uint i = 0; i < signers.length; i++) {
            require(signers[i] > lastSigner, "INVALID_SIGNERS_ORDER");
            lastSigner = signers[i];
            if (!verifySignature(signHash, signers[i], signatures[i])) {
                return false;
            }
        }
        return true;
    }

    function verifySignature(
        bytes32 signHash,
        address signer,
        bytes memory signature
    ) internal view returns (bool) {
        if (signer == address(0)) {
            return false;
        }

        return
            signer.isContract()
                ? verifyERC1271Signature(signHash, signer, signature)
                : verifyEOASignature(signHash, signer, signature);
    }

    function recoverECDSASigner(
        bytes32 signHash,
        bytes memory signature
    ) internal pure returns (address) {
        if (signature.length != 65) {
            return address(0);
        }

        bytes32 r;
        bytes32 s;
        uint8 v;
        // we jump 32 (0x20) as the first slot of bytes contains the length
        // we jump 65 (0x41) per signature
        // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
        // solhint-disable-next-line no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := and(mload(add(signature, 0x41)), 0xff)
        }
        // See https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol
        if (
            uint256(s) >
            0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
        ) {
            return address(0);
        }
        if (v == 27 || v == 28) {
            return ecrecover(signHash, v, r, s);
        } else {
            return address(0);
        }
    }

    function verifyEOASignature(
        bytes32 signHash,
        address signer,
        bytes memory signature
    ) private pure returns (bool success) {
        if (signer == address(0)) {
            return false;
        }

        require(
            signature.length == 65 || signature.length == 66,
            "INVALID_SIGNATURE_LENGTH"
        );

        bool trimmed = false;
        if (signature.length == 66) {
            // Strip off the last byte of the signature by updating the length
            // solhint-disable-next-line no-inline-assembly
            assembly {
                mstore(signature, 65)
            }

            trimmed = true;
        }

        success = (signer == recoverECDSASigner(signHash, signature));
        if (!success) {
            bytes32 hash = keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", signHash)
            );
            success = (signer == recoverECDSASigner(hash, signature));
        }

        if (trimmed) {
            // Restore the signature length
            // solhint-disable-next-line no-inline-assembly
            assembly {
                mstore(signature, 66)
            }
        }
    }

    function verifyERC1271Signature(
        bytes32 signHash,
        address signer,
        bytes memory signature
    ) private view returns (bool) {
        bytes memory callData = abi.encodeWithSelector(
            ERC1271.isValidSignature.selector,
            signHash,
            signature
        );
        (bool success, bytes memory result) = signer.staticcall(callData);
        return (success &&
            result.length == 32 &&
            result.toBytes4(0) == ERC1271_MAGICVALUE);
    }
}