pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import { ProofConverter } from "./utils/ProofConverter.sol";

import { HonkVerifier } from "../../contracts/circuit/ultra-verifier/plonk_vk.sol";
//import { HonkVerifier } from "../../circuits/target/contract.sol";
import { Starter } from "../../contracts/circuit/Starter.sol";


contract VerifyScript is Script {
    Starter public starter;
    HonkVerifier public verifier;

    function setUp() public {}

    function run() public returns (bool) {
        //uint256 deployerPrivateKey = vm.envUint("LOCALHOST_PRIVATE_KEY");
        //vm.startBroadcast(deployerPrivateKey);

        verifier = new HonkVerifier();
        starter = new Starter(verifier);

        bytes memory proof_w_inputs = vm.readFileBinary("./circuits/target/confidential_licensing_agreement_proof.bin");
        bytes memory proofBytes = ProofConverter.sliceAfter64Bytes(proof_w_inputs);    /// @dev - In case of that there are 2 public inputs (bytes32 * 2 = 64 bytes), the proof file includes 96 bytes of the public inputs at the beginning. Hence it should be removed by using this function.
        
        //string memory proof = vm.readLine("./circuits/target/confidential_licensing_agreement_proof.bin");
        //bytes memory proofBytes = vm.parseBytes(proof);

        bytes32[] memory correctPublicInputs = new bytes32[](2);
        correctPublicInputs[0] = bytes32(0x0000000000000000000000000000000000000000000000000000000000000003);
        correctPublicInputs[1] = bytes32(0x0d550adf957548876e708338ed4e94a657a3ae4a99538d716faf422679df79d8);

        bool isValidProof = starter.verifyEqual(proofBytes, correctPublicInputs);
        return isValidProof;
    }
}
