#!/usr/bin/env node
"use strict";
const fs = require("fs");
const path = require("path");
const snarkjs = require("snarkjs");
const { buildPoseidon } = require("circomlibjs");

const ROOT = path.join(__dirname, "..");
const buildDir = path.join(ROOT, "build");
const circuitName = "hello_hash";

async function main() {
  const wasmPath = path.join(buildDir, `${circuitName}_js`, `${circuitName}.wasm`);
  const zkeyPath = path.join(buildDir, `${circuitName}_final.zkey`);
  if (!fs.existsSync(wasmPath) || !fs.existsSync(zkeyPath)) {
    console.error("Run setup_zk.sh first.");
    process.exit(1);
  }
  const poseidon = await buildPoseidon();
  const a = 1;
  const b = 2;
  const out = poseidon.F.toObject(poseidon([a, b])).toString();
  const input = { a, b, out };
  const { proof, publicSignals } = await snarkjs.groth16.fullProve(input, wasmPath, zkeyPath);
  const proofCalldata = await snarkjs.groth16.exportSolidityCallData(proof, publicSignals);
  const argv = JSON.parse("[" + proofCalldata + "]");
  const [pA, pB, pC, pubSignals] = argv;
  const proofJson = {
    a0: pA[0].toString(),
    a1: pA[1].toString(),
    b00: pB[0][0].toString(),
    b01: pB[0][1].toString(),
    b10: pB[1][0].toString(),
    b11: pB[1][1].toString(),
    c0: pC[0].toString(),
    c1: pC[1].toString(),
    pub0: pubSignals[0].toString(),
  };
  fs.writeFileSync(path.join(buildDir, "proof.json"), JSON.stringify(proofJson, null, 2));
  console.log("Wrote build/proof.json");
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
