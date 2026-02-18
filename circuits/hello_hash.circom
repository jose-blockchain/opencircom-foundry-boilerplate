pragma circom 2.0.0;

include "hashing/poseidon.circom";

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
