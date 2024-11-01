// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/Counter.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployCounter is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy implementation
        Counter counter = new Counter();
        console.log("Implementation deployed to:", address(counter));

        // Encode initialize function call
        bytes memory data = abi.encodeWithSelector(Counter.initialize.selector);

        // Deploy proxy
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(counter),
            data
        );
        console.log("Proxy deployed to:", address(proxy));

        // Verify deployment
        Counter proxiedCounter = Counter(address(proxy));
        console.log("Initial count:", proxiedCounter.getCount());

        vm.stopBroadcast();
    }
} 