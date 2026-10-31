# OpenZeppelin Solidity dependency snapshot

This directory contains the unmodified minimal dependency closure used by
`DIContributionRegistry` and `ERC1967Proxy`: 14 Solidity files from the official
`@openzeppelin/contracts@5.4.0` and `@openzeppelin/contracts-upgradeable@5.4.0`
npm packages. No project package or lockfile is changed by this snapshot.

`PROVENANCE.json` records the exact npm tarball URLs, verified npm SHA-512
integrities, tarball SHA-256 hashes, and per-source SHA-256 hashes. The package
tarballs omit license text; each package's `LICENSE` was obtained from its
official OpenZeppelin repository at tag `v5.4.0`, with URL and hash recorded.
All original SPDX headers are preserved.

The compiler reads these local sources only, checks their hashes and license
hashes, and embeds provenance and storage layout in the generated artifact.
Changing a dependency requires explicit review and regenerating that artifact.

The registry's permanent `recorded` mapping occupies slot 0. Ownership,
pending ownership and initialization use OpenZeppelin's ERC-7201 namespaces.
Future upgrades must retain this mapping layout and the inherited namespaces;
new ordinary storage fields may be appended. Compatibility is additionally
exercised by an in-memory V2 upgrade that appends a field and initializer.
