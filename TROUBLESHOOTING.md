# Troubleshooting

This project wires together Node.js, Circom, snarkjs, and Foundry. Most local failures come from one of those tools missing, generated ZK artifacts being stale, or the `forge-std` submodule not being initialized.

## `circom: command not found`

Install Circom 2.x and make sure the `circom` binary is on your `PATH`.

```bash
circom --version
```

After installing Circom, rerun the full pipeline:

```bash
npm test
```

## `forge: command not found`

Install Foundry, then reload your shell so `forge` is available.

```bash
forge --version
```

Use `npm run compile` or `npm test` after Foundry is installed.

## `lib/forge-std` is missing

The Foundry test helpers are checked out as a git submodule. If `forge build` or `forge test` cannot resolve `forge-std`, initialize the submodule from the repository root:

```bash
git submodule update --init --recursive
```

`lib/forge-std` is pinned by `foundry.lock`, so avoid running bare `forge install` on a fresh checkout.

## `opencircom` circuits are missing

The compile script expects `node_modules/opencircom/circuits` to exist. Install the Node dependencies first:

```bash
npm install
npm run compile:circuits
```

If you set a custom `OPENCIRCOM` path, make sure it points at a directory that contains the opencircom circuit files.

## `build/proof.json` is missing

Forge tests read the sample Groth16 calldata from `build/proof.json`. Regenerate the ZK setup and proof:

```bash
npm run compile:circuits
npm run setup:zk
npm run generate:proof
forge test
```

`npm test` runs those steps in order and is the easiest way to rebuild everything.

## `src/HelloHashVerifier.sol` was deleted or is stale

`npm run setup:zk` exports the Solidity verifier from `build/hello_hash_final.zkey` and rewrites `src/HelloHashVerifier.sol`.

```bash
npm run compile:circuits
npm run setup:zk
forge build
```

If the circuit changed, rerun `npm run generate:proof` before `forge test` so the proof calldata matches the verifier.

## Tests fail after editing the circuit

Clean generated artifacts and rebuild the full stack:

```bash
npm run clean
git submodule update --init --recursive
npm install
npm test
```

This removes `build/`, `out/`, and `cache/`, then regenerates the circuit artifacts, trusted setup, verifier, sample proof, and Forge build outputs.

## `setup_zk.sh` fails while generating the Powers of Tau

The setup script uses common shell tools such as `head`, `xxd`, and `openssl`. On Windows, run it from Git Bash, WSL, or another shell that provides those commands.

You can also rerun the command after deleting the partial setup files in `build/`:

```bash
npm run clean
npm test
```
