// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IPoolInitializer.sol";
import "./PeripheryImmutableState.sol";
import "../../core/interfaces/IUniswapV3Factory.sol";
import "../../core/interfaces/IUniswapV3Pool.sol";

abstract contract PoolInitializer is IPoolInitializer, PeripheryImmutableState {
    /// @inheritdoc IPoolInitializer
    function createAndInitializePoolIfNecessary(
        address token0,
        address token1,
        uint24 fee,
        uint160 sqrtPriceX96
    ) external payable override returns (address pool) {
        if (token0 > token1) (token0, token1) = (token1, token0);
        require(token0 != address(0));
        pool = IUniswapV3Factory(factory).getPool(token0, token1, fee);

        if (pool == address(0)) {
            pool = IUniswapV3Factory(factory).createPool(token0, token1, fee);
            IUniswapV3Pool(pool).initialize(sqrtPriceX96);
        } else {
            (uint160 sqrtPriceX96Existing, , , , , , ) = IUniswapV3Pool(pool).slot0();
            if (sqrtPriceX96Existing == 0) {
                IUniswapV3Pool(pool).initialize(sqrtPriceX96);
            }
        }
    }
}
