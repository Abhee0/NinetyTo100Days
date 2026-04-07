// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {OpsReady} from "./OpsReady.sol"; // Gelato boilerplate

contract AutoHarvester is OpsReady {
    uint256 public lastHarvest;
    uint256 public harvestInterval = 1 days;
    address public yieldVault;

    constructor(address _ops, address _vault) OpsReady(_ops) {
        yieldVault = _vault;
        lastHarvest = block.timestamp;
    }

    // 1. The Checker Function (Called for free by Gelato Keepers)
    // Returns true and the payload if it's time to execute
    function checker() external view returns (bool canExec, bytes memory execPayload) {
        canExec = (block.timestamp >= lastHarvest + harvestInterval);
        execPayload = abi.encodeWithSelector(this.harvestAndCompound.selector);
    }

    // 2. The Target Function (Executed by Gelato)
    function harvestAndCompound() external onlyOps {
        // Enforce the time requirement on-chain for security
        require(block.timestamp >= lastHarvest + harvestInterval, "Too early");
        
        // Execute protocol logic
        IYieldVault(yieldVault).harvest();
        
        lastHarvest = block.timestamp;
    }
}

interface IYieldVault {
    function harvest() external;
}