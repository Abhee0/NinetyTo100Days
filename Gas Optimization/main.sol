// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract GasOptimizer {
    
    // ❌ BAD: This takes up 3 separate 256-bit storage slots.
    // Writing to this struct costs ~60,000 gas.
    struct InefficientUser {
        bool isActive;       // 1 byte (Takes up a full 32-byte slot)
        uint256 lastLogin;   // 32 bytes (Takes up a full 32-byte slot)
        address wallet;      // 20 bytes (Takes up a full 32-byte slot)
    }

    // ✅ GOOD: This packs perfectly into a SINGLE 256-bit storage slot.
    // Writing to this struct costs ~20,000 gas. (A 66% reduction!)
    struct PackedUser {
        address wallet;      // 160 bits
        uint64 lastLogin;    // 64 bits (Timestamps only need 64 bits for the next billion years)
        bool isActive;       // 8 bits
                             // Total = 232 bits (Fits comfortably inside 256 bits)
    }

    PackedUser public currentUser;

    function updateUserData(address _wallet, bool _active) external {
        // Because the variables are packed, updating this entire struct 
        // only triggers a single SSTORE operation under the hood.
        currentUser = PackedUser({
            wallet: _wallet,
            lastLogin: uint64(block.timestamp),
            isActive: _active
        });
    }
}