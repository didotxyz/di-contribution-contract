# DI Contribution Registry — audit source package

[English](README.md) · [简体中文](README_CN.md)

Public, standalone source package for auditing **DIContributionRegistry**, the DI Engine result-contribution registry on BNB Smart Chain. This is an audit submission, **not an audit certification**.

## Start here

- [Main contract](contracts/DIContributionRegistry.sol)
- [ERC1967 proxy source](contracts/vendor/openzeppelin-5.4.0/@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol)
- [Complete Standard JSON compiler input](artifacts/standard-input.json)
- [Implementation/proxy ABI, bytecode and storage layout](artifacts/registry-artifact.json)
- [Historical mainnet deployment](deployments/bsc-mainnet.json)
- [Audit scope and trust boundaries](AUDIT_SCOPE.md)
- [Dependency provenance and licenses](contracts/vendor/openzeppelin-5.4.0/PROVENANCE.json)
- [Source export provenance](SOURCE_PROVENANCE.json)

## What the contract records

Users call `contribute(bytes32 commitment, uint32 protocolVersion)` on the proxy, paying transaction gas. The contract records `recorded[wallet][commitment] = true` and emits `ContributionRecorded(wallet, commitment, protocolVersion)`. It rejects zero commitments, unsupported protocol versions and duplicate wallet/commitment pairs.

The on-chain value is a commitment, not report plaintext, a model, training data or a points balance. Data-use consent, report ownership, snapshot creation, actual model use, contribution verification and reward accounting are application responsibilities. Recording a hash alone does not certify report correctness or model adoption.

## Deployment references

| Field | Value |
| --- | --- |
| Network | BNB Smart Chain mainnet, chain ID 56 |
| User-facing proxy | [`0x99eF9777462152Fe2d0271FC326022a639B3810b`](https://bscscan.com/address/0x99eF9777462152Fe2d0271FC326022a639B3810b) |
| Implementation at deployment | [`0xD4ec25b03926cb2452BD57B88931b3cAf8CA31bF`](https://bscscan.com/address/0xD4ec25b03926cb2452BD57B88931b3cAf8CA31bF) |
| Architecture | OpenZeppelin UUPS implementation + ERC1967Proxy |
| Protocol version | 1 |

These addresses come from the 2026-10-17 deployment record. **Current implementation, owner and explorer verification have not been rechecked for this export.** Audit both the implementation and proxy, and independently resolve the current ERC1967 implementation slot. This repository contains no deployment or upgrade transaction commands.

## Reproduce the compilation

- Compiler: Solidity `0.8.30+commit.73712a01`
- Optimizer: enabled, 200 runs
- EVM: `paris`
- Metadata: `bytecodeHash: none`, `appendCBOR: false`
- OpenZeppelin: exact 5.4.0 vendored dependency closure, 14 Solidity files
- Total Solidity sources: 15

With the pinned native Solidity compiler installed:

```sh
solc --version
solc --standard-json < artifacts/standard-input.json > compiler-output.json
```

Use the exact settings and source-unit names in the provided input. Compare `DIContributionRegistry.sol:DIContributionRegistry` and `@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol:ERC1967Proxy` against `artifacts/registry-artifact.json`. The implementation runtime contains the UUPS `__self` immutable: use the included immutable references and actual implementation address when comparing deployed code.

On 2026-10-31 the exporter used the existing pinned solc-js compiler offline and reproduced the stored ABI, creation/runtime bytecode for both contracts, implementation storage layout and immutable references. This is compilation equivalence only, **not an independent security audit, current-chain verification or a fresh EVM test run**.

Verify package file integrity with:

```sh
shasum -a 256 -c SHA256SUMS
```

All Solidity dependencies and their license texts are included; no production application configuration, credentials or user data is included. The application test harness is not part of this contract-only package. Auditors should run their own fuzz, invariant, upgrade and deployment-state tests.

## License

The registry source declares MIT. Vendored OpenZeppelin code retains its upstream SPDX headers, package license texts and provenance. See [LICENSE](LICENSE).
