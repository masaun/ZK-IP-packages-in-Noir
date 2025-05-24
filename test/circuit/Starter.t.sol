pragma solidity ^0.8.17;

import { HonkVerifier } from "../../contracts/circuit/ultra-verifier/plonk_vk.sol";
import { Starter } from "../../contracts/circuit/Starter.sol";
//import "../circuits/target/contract.sol";
import "forge-std/console.sol";

import "forge-std/Test.sol";
import {NoirHelper} from "foundry-noir-helper/NoirHelper.sol";


contract StarterTest is Test {
    Starter public starter;
    HonkVerifier public verifier;
    NoirHelper public noirHelper;

    function setUp() public {
        noirHelper = new NoirHelper();
        verifier = new HonkVerifier();
        starter = new Starter(verifier);
    }

    function test_verifyProof() public {
        noirHelper.withInput("x", 3)
                  .withInput("y", 3)
                  .withInput("nullifier", bytes32(uint256(0x0d550adf957548876e708338ed4e94a657a3ae4a99538d716faf422679df79d8)));
                  //.withInput("return", bytes32(uint256(0x0d550adf957548876e708338ed4e94a657a3ae4a99538d716faf422679df79d8)));

        /// @dev - [Error]: Failed to open data file for writing: "./target/test_verifyProof.proof/proof"
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_verifyProof", 2);
        starter.verifyEqual(proof, publicInputs);
    }

    function test_wrongProof() public {
        noirHelper.clean();
        noirHelper.withInput("x", 5)
                  .withInput("y", 5)
                  .withInput("nullifier", bytes32(uint256(0x0d550adf957548876e708338ed4e94a657a3ae4a99538d716faf422679df79d8)));
                  //.withInput("return", bytes32(uint256(0x0d550adf957548876e708338ed4e94a657a3ae4a99538d716faf422679df79d8)));

        /// @dev - [Error]: Failed to open data file for writing: "./target/test_wrongProof.proof/proof"
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_wrongProof", 2);

        /// @dev - Create a fake public input, which should fail because the public input is wrong
        bytes32[] memory fakePublicInputs = new bytes32[](2);
        fakePublicInputs[0] = publicInputs[0];
        fakePublicInputs[1] = bytes32(uint256(0xddddd));  // @dev - This is wrong publicInput ("nulifieir")

        /// @dev - Verify the proof, which should be reverted
        vm.expectRevert();
        starter.verifyEqual(proof, fakePublicInputs);
    }

    // function test_all() public {
    //     // forge runs tests in parallel which messes with the read/writes to the proof file
    //     // Run tests in wrapper to force them run sequentially
    //     verifyProof();
    //     wrongProof();
    // }

}
