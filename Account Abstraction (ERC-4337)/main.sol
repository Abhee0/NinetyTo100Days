// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@account-abstraction/contracts/interfaces/IPaymaster.sol";

contract SimpleGasSponsor is IPaymaster {
    address public immutable owner;

    constructor(address _owner) {
        owner = _owner;
    }

    /**
     * @dev Validates if the paymaster is willing to pay for this transaction.
     * In a real dApp, you might check if the user has a valid subscription 
     * or if they are within their monthly "free" transaction limit.
     */
    function validatePaymasterUserOp(
        UserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 maxCost
    ) external view override returns (bytes memory context, uint256 validationData) {
        // For this demo, we sponsor transactions if they are calling 
        // a specific "New User Onboarding" function.
        bytes4 selector = bytes4(userOp.callData[0:4]);
        
        bool isAllowed = (selector == bytes4(keccak256("onboardUser()")));
        
        if (!isAllowed) {
            // Return SIG_VALIDATION_FAILED (1) if we don't want to pay
            return ("", 1); 
        }

        // Return 0 to indicate the Paymaster will cover the gas cost
        return ("", 0);
    }

    function postOp(
        PostOpMode mode,
        bytes calldata context,
        uint256 actualGasCost
    ) external override {
        // Optional logic to run after the transaction (e.g., logging)
    }
}