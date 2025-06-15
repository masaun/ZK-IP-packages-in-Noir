pragma solidity ^0.8.28;

import { HonkVerifier } from "./circuit-for-ip-protection-for-derivative-works/honk-verifier/plonk_vk.sol";
//import "../circuits/target/contract.sol";

contract DerivativeWorkProofVerifier {
    HonkVerifier public verifier;

    constructor(HonkVerifier _verifier) {
        verifier = _verifier;
    }

    function verifyDerivativeWorkProof(bytes calldata proof, bytes32[] calldata y) public view returns (bool) {
        bool proofResult = verifier.verify(proof, y);
        require(proofResult, "Proof is not valid");
        return proofResult;
    }
}
