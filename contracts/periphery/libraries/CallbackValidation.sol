// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../core/interfaces/IUniswapV3Pool.sol";
import "../../core/interfaces/IUniswapV3Factory.sol";

/// @title Provides validation for callbacks from Uniswap V3 Pools
library CallbackValidation {
    /// @notice Returns the address of a valid Uniswap V3 Pool
    /// @param factory The contract address of the Uniswap V3 factory
    /// @param tokenA The contract address of either token0 or token1
    /// @param tokenB The contract address of the other token
    /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
    /// @return pool The V3 pool contract address
    function verifyCallback(
        address factory,
        address tokenA,
        address tokenB,
        uint24 fee
    ) internal view returns (IUniswapV3Pool pool) {
        address expectedPool = IUniswapV3Factory(factory).getPool(tokenA, tokenB, fee);
        require(msg.sender == expectedPool, "Invalid pool callback");
        pool = IUniswapV3Pool(msg.sender);
    }
}
