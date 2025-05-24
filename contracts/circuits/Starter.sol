pragma solidity ^0.8.28;

import { HonkVerifier } from "./circuit-for-confidential-licensing-agreements/honk-verifier/plonk_vk.sol";
//import { HonkVerifier } from "./circuit-for-privacy-preserving-proof-of-authorship/honk-verifier/plonk_vk.sol";
//import { HonkVerifier } from "./circuit-for-private-royalty-distribution/honk-verifier/plonk_vk.sol";
//import { HonkVerifier } from "./circuit-for-selective-disclosure-in-derivative-works/honk-verifier/plonk_vk.sol";
//import { HonkVerifier } from "./circuit-for-AI-model-provenance-and-usage-rights/honk-verifier/plonk_vk.sol";
//import "../circuits/target/contract.sol";

contract Starter {
    HonkVerifier public verifier;

    constructor(HonkVerifier _verifier) {
        verifier = _verifier;
    }

    function verifyEqual(bytes calldata proof, bytes32[] calldata y) public view returns (bool) {
        bool proofResult = verifier.verify(proof, y);
        require(proofResult, "Proof is not valid");
        return proofResult;
    }
}
