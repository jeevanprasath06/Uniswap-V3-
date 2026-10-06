// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Pool state that never changes
/// @notice These methods do not mutate the pool and never return different values
interface IUniswapV3PoolImmutables {
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function fee() external view returns (uint24);
    function tickSpacing() external view returns (int24);
    function maxLiquidityPerTick() external view returns (uint128);
}
