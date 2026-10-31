# Audit scope / 审计范围

## In scope

- `contracts/DIContributionRegistry.sol` and the complete vendored import closure.
- ERC1967Proxy construction with atomic `initialize(initialOwner)` calldata.
- UUPS authorization, implementation initialization lock, proxy-only entry points, two-step ownership transfer, disabled ownership renunciation.
- Permanent slot-0 `recorded` mapping; inherited ERC-7201 storage namespaces; compatibility of any proposed upgrade.
- Event/calldata/state binding, empty/duplicate/version rejection and nonpayable behavior.
- Exact compiler settings, ABI, bytecode, immutable references and deployment provenance.

The registry is permissionless: any wallet can submit a nonzero commitment for itself. It does not validate a report, user consent or reward eligibility. Another wallet can record the same commitment; uniqueness is per wallet and commitment, not globally per report.

## Upgrade trust

The owner can authorize a new UUPS implementation, potentially changing future behavior. Current append-only behavior is not an immutable guarantee against an authorized malicious upgrade. Verify the current owner, pending owner, upgrade history, implementation slot, code and operational controls. Do not assume ownership has been moved to a multisig merely because two-step transfer is supported.

The implementation constructor disables initializers. The proxy must be initialized atomically in its constructor. Direct implementation contribution calls and repeated initialization must fail. Review the consequences of an uninitialized proxy, incorrect implementation or incompatible storage upgrade.

## Application boundary (not implemented by this contract)

The intended application commitment uses keccak256 over ABI-encoded domain, chain ID, registry address, submitting wallet, protocol version, snapshot SHA-256 and random salt. Application-side hashing and consent handling are not certified by this source package.

Report author identity, explicit permissions for DI to use the result, report/snapshot storage, chain finality and reorg handling, backend recovery, and exactly-once off-chain points settlement require a separate application audit. This contract does not custody tokens, mint points, transfer rewards or operate the website check-in feature.

## Auditor deliverables

Identify the exact reviewed repository commit and source hashes, compiler settings, actual chain state checked and findings with severity, reproduction and remediation. Include initialization/authorization/upgrade/storage tests and contribution event/replay tests. Distinguish source findings, historical deployment facts and current on-chain observations.

No external audit result is included in this submission. Please do not publish exploit details or private application data in a public issue; coordinate sensitive findings privately with the project contact who supplied this repository.
