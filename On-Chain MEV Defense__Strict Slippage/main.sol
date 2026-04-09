// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SafeSwapper {
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    // A wrapper function forcing strict MEV protections
    function executeSafeSwap(
        address tokenIn,
        uint256 amountIn,
        uint256 amountOutMin, // 🛡️ MEV Defense 1: Minimum acceptable output
        bytes calldata swapData
    ) external {
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenIn).approve(router, amountIn);

        // 🛡️ MEV Defense 2: Enforcing a strict deadline prevents miners from 
        // holding the transaction and executing it later when market conditions change.
        uint256 strictDeadline = block.timestamp + 5 minutes;

        (bool success, bytes memory returnData) = router.call(
            abi.encodePacked(swapData, strictDeadline)
        );
        require(success, "Swap failed");

        // Verifying the slippage condition was actually met by the router
        uint256 amountReceived = abi.decode(returnData, (uint256));
        require(amountReceived >= amountOutMin, "MEV Attack Detected: High Slippage");
    }
}