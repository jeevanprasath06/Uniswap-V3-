// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Math library for liquidity
library LiquidityMath {
    /// @notice Add a signed liquidity delta to liquidity that is known to be >= 0
    /// @param x The liquidity to add to
    /// @param y The addend that is signed
    /// @return z The liquidity after add
    function addDelta(uint128 x, int128 y) internal pure returns (uint128 z) {
        if (y < 0) {
            require((z = x - uint128(-y)) < x, "LS");
        } else {
            require((z = x + uint128(y)) >= x, "LA");
        }
    }
}
