// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/HelloHashVerifier.sol";
import "../src/PoseidonProofGateway.sol";

contract HelloHashTest is Test {
    HelloHashVerifier public verifier;
    PoseidonProofGateway public gateway;

    function setUp() public {
        verifier = new HelloHashVerifier();
        gateway = new PoseidonProofGateway(verifier);
    }

    function test_RealProofVerifies() public {
        string memory json = vm.readFile("build/proof.json");
        uint256 a0 = vm.parseJsonUint(json, ".a0");
        uint256 a1 = vm.parseJsonUint(json, ".a1");
        uint256 b00 = vm.parseJsonUint(json, ".b00");
        uint256 b01 = vm.parseJsonUint(json, ".b01");
        uint256 b10 = vm.parseJsonUint(json, ".b10");
        uint256 b11 = vm.parseJsonUint(json, ".b11");
        uint256 c0 = vm.parseJsonUint(json, ".c0");
        uint256 c1 = vm.parseJsonUint(json, ".c1");
        uint256 pub0 = vm.parseJsonUint(json, ".pub0");

        uint256[2] memory pA = [a0, a1];
        uint256[2][2] memory pB = [[b00, b01], [b10, b11]];
        uint256[2] memory pC = [c0, c1];
        uint256[1] memory pubSignals = [pub0];

        bool ok = verifier.verifyProof(pA, pB, pC, pubSignals);
        assertTrue(ok);
    }

    function test_GatewaySubmitsProofAndVerifies() public {
        string memory json = vm.readFile("build/proof.json");
        uint256 a0 = vm.parseJsonUint(json, ".a0");
        uint256 a1 = vm.parseJsonUint(json, ".a1");
        uint256 b00 = vm.parseJsonUint(json, ".b00");
        uint256 b01 = vm.parseJsonUint(json, ".b01");
        uint256 b10 = vm.parseJsonUint(json, ".b10");
        uint256 b11 = vm.parseJsonUint(json, ".b11");
        uint256 c0 = vm.parseJsonUint(json, ".c0");
        uint256 c1 = vm.parseJsonUint(json, ".c1");
        uint256 pub0 = vm.parseJsonUint(json, ".pub0");

        uint256[2] memory pA = [a0, a1];
        uint256[2][2] memory pB = [[b00, b01], [b10, b11]];
        uint256[2] memory pC = [c0, c1];
        uint256[1] memory pubSignals = [pub0];

        bool ok = gateway.submitProof(pA, pB, pC, pubSignals);
        assertTrue(ok);
        assertEq(gateway.lastVerifiedHash(), pub0);
    }
}
