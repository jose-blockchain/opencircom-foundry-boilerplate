pragma circom 2.0.0;

// Poseidon is a ZK-friendly hash - much cheaper to prove inside a circuit than keccak256/sha256.
include "hashing/poseidon.circom";

// Proves you know two private inputs a and b whose Poseidon hash equals the
// public value out, without revealing a or b. a and b are the private witness;
// out is public and is checked against the hash the circuit computes below.
template HelloHash() {
    signal input a;
    signal input b;
    signal input out;
    component h = Poseidon(2);
    h.inputs[0] <== a;
    h.inputs[1] <== b;
    h.out === out;
}

component main {public [out]} = HelloHash();
