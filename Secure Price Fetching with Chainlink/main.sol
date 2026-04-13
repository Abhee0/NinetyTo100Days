// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract SecurePriceConsumer {
    AggregatorV3Interface internal priceFeed;

    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    /**
     * @dev Returns the latest price but adds critical security checks:
     * 1. Ensure the price is positive.
     * 2. Ensure the data was updated within a specific "heartbeat" (e.g., 1 hour).
     * 3. Ensure the round is complete.
     */
    function getSafePrice() public view returns (int256) {
        (
            uint80 roundId,
            int256 price,
            ,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        // Security Check 1: Stale data check (heartbeat = 3600 seconds)
        require(updatedAt > 0, "Oracle: Incomplete round");
        require(block.timestamp - updatedAt <= 3600, "Oracle: Stale price data");
        
        // Security Check 2: Verify round completeness
        require(answeredInRound >= roundId, "Oracle: Round not complete");

        // Security Check 3: Positive price check
        require(price > 0, "Oracle: Negative/Zero price");

        return price;
    }
}