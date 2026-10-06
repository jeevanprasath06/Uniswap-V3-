// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../core/interfaces/IUniswapV3Factory.sol";
import "../../core/interfaces/IUniswapV3Pool.sol";
import "../../core/interfaces/callback/IUniswapV3MintCallback.sol";
import "../../core/libraries/TickMath.sol";
import "../libraries/PoolAddress.sol";
import "../libraries/LiquidityAmounts.sol";
import "../libraries/CallbackValidation.sol";
import "./PeripheryPayments.sol";
import "./PeripheryImmutableState.sol";

abstract contract LiquidityManagement is IUniswapV3MintCallback, PeripheryPayments {
    struct MintCallbackData {
        PoolAddress.PoolKey poolKey;
        address payer;
    }

    /// @inheritdoc IUniswapV3MintCallback
    function uniswapV3MintCallback(
        uint256 amount0Owed,
        uint256 amount1Owed,
        bytes calldata data
    ) external override {
        MintCallbackData memory decoded = abi.decode(data, (MintCallbackData));
        CallbackValidation.verifyCallback(factory, decoded.poolKey.token0, decoded.poolKey.token1, decoded.poolKey.fee);

        if (amount0Owed > 0) pay(decoded.poolKey.token0, decoded.payer, msg.sender, amount0Owed);
        if (amount1Owed > 0) pay(decoded.poolKey.token1, decoded.payer, msg.sender, amount1Owed);
    }

    struct AddLiquidityParams {
        address token0;
        address token1;
        uint24 fee;
        address recipient;
        int24 tickLower;
        int24 tickUpper;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
    }

    /// @notice Add liquidity to an initialized pool
    function addLiquidity(AddLiquidityParams memory params)
        internal
        returns (
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1,
            IUniswapV3Pool pool
        )
    {
        PoolAddress.PoolKey memory poolKey = PoolAddress.getPoolKey(params.token0, params.token1, params.fee);
        address poolAddress = IUniswapV3Factory(factory).getPool(poolKey.token0, poolKey.token1, poolKey.fee);
        require(poolAddress != address(0), "Pool does not exist");
        pool = IUniswapV3Pool(poolAddress);

        (uint160 sqrtPriceX96, , , , , , ) = pool.slot0();
        uint160 sqrtRatioAX96 = TickMath.getSqrtRatioAtTick(params.tickLower);
        uint160 sqrtRatioBX96 = TickMath.getSqrtRatioAtTick(params.tickUpper);

        liquidity = LiquidityAmounts.getLiquidityForAmounts(
            sqrtPriceX96,
            sqrtRatioAX96,
            sqrtRatioBX96,
            params.amount0Desired,
            params.amount1Desired
        );

        (amount0, amount1) = pool.mint(
            params.recipient,
            params.tickLower,
            params.tickUpper,
            liquidity,
            abi.encode(MintCallbackData({poolKey: poolKey, payer: msg.sender}))
        );

        require(amount0 >= params.amount0Min, "Price slippage amount0");
        require(amount1 >= params.amount1Min, "Price slippage amount1");
    }
}
