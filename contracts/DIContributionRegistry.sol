// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Ownable2StepUpgradeable} from "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";

/// @notice Append-only report-version commitments. Users pay transaction gas.
/// @dev UUPS upgrades require the owner. No tokens, points, custody or report plaintext.
/// Deploy behind ERC1967Proxy with initialize(deployingWallet) in its constructor.
contract DIContributionRegistry is UUPSUpgradeable, Ownable2StepUpgradeable {
    uint32 public constant PROTOCOL_VERSION = 1;
    // Storage slot 0 is permanent. Future versions may append fields; never
    // reorder or change this mapping. OZ ownership/initialization use ERC-7201.
    mapping(address => mapping(bytes32 => bool)) public recorded;

    event ContributionRecorded(
        address indexed contributor,
        bytes32 indexed commitment,
        uint32 protocolVersion
    );

    error UnsupportedProtocol();
    error EmptyCommitment();
    error AlreadyRecorded();
    error OwnershipRenunciationDisabled();

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) external initializer onlyProxy {
        __Ownable_init(initialOwner);
        __Ownable2Step_init();
        __UUPSUpgradeable_init();
    }

    function renounceOwnership() public pure override {
        revert OwnershipRenunciationDisabled();
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function contribute(bytes32 commitment, uint32 protocolVersion) external onlyProxy {
        if (protocolVersion != PROTOCOL_VERSION) revert UnsupportedProtocol();
        if (commitment == bytes32(0)) revert EmptyCommitment();
        if (recorded[msg.sender][commitment]) revert AlreadyRecorded();
        recorded[msg.sender][commitment] = true;
        emit ContributionRecorded(msg.sender, commitment, protocolVersion);
    }
}
