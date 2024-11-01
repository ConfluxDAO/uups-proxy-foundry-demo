// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract CounterV2 is UUPSUpgradeable, OwnableUpgradeable {
    uint256 private count;

    event CountChanged(uint256 count);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function increment() public {
        count += 1;
        emit CountChanged(count);
    }

    function getCount() public view returns (uint256) {
        return count;
    }

    function reset() public {
        count = 0;
        emit CountChanged(count);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
} 