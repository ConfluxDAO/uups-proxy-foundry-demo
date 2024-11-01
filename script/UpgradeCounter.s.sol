// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/Counter.sol";
import "../src/CounterV2.sol";

contract UpgradeCounter is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");

        // Test before upgrade
        console.log("============ Before Upgrade ============");
        Counter counter = Counter(proxyAddress);
        uint256 valueBefore = counter.getCount();
        console.log("Current count:", valueBefore);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy new implementation
        CounterV2 counterV2 = new CounterV2();
        console.log("\n============ Deploying New Implementation ============");
        console.log("New implementation:", address(counterV2));

        // Upgrade proxy to new implementation
        Counter(proxyAddress).upgradeToAndCall(
            address(counterV2),
            "" // Empty bytes string since we don't need to call any initialization function
        );

        vm.stopBroadcast();

        // Test after upgrade
        console.log("\n============ After Upgrade ============");
        CounterV2 upgradedCounter = CounterV2(proxyAddress);
        uint256 valueAfter = upgradedCounter.getCount();
        console.log("Count after upgrade:", valueAfter);

        vm.startBroadcast(deployerPrivateKey);
        upgradedCounter.increment();
        vm.stopBroadcast();

        uint256 valueAfterIncrement = upgradedCounter.getCount();
        console.log("Count after increment:", valueAfterIncrement);

        vm.startBroadcast(deployerPrivateKey);
        upgradedCounter.reset();
        vm.stopBroadcast();

        uint256 valueAfterReset = upgradedCounter.getCount();
        console.log("Count after reset:", valueAfterReset);

        // Verify upgrade results
        require(valueAfter == valueBefore, "State verification failed: Value changed during upgrade");
        require(valueAfterIncrement == valueAfter + 1, "Function verification failed: Increment not working");
        require(valueAfterReset == 0, "Function verification failed: Reset not working");

        console.log("\n============ Upgrade Successful ============");
        console.log("1. State preserved: Initial count maintained after upgrade");
        console.log("2. New functions working: Increment and Reset successfully added");
    }
}