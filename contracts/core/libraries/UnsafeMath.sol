// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Math functions that do not check for overflow or underflow
/// @notice Contains methods for doing math operations that are guaranteed to not overflow or underflow
library UnsafeMath {
    /// @notice Returns ceil(x / y)
    /// @dev division by zero has unspecified behavior, and must be checked externally
    /// @param x The dividend
    /// @param y The divisor
    /// @return z The quotient, ceil(x / y)
    function divRoundingUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        unchecked {
            assembly {
                z := add(div(x, y), gt(mod(x, y), 0))
            }
        }
    }
}
