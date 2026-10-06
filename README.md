# Uniswap V3 Smart Contracts Implementation

A complete, production-grade implementation of the **Uniswap V3** core protocol and periphery contracts in Solidity, built with Foundry.

---

## 📐 Architecture Overview

```
contracts/
├── core/
│   ├── interfaces/
│   │   ├── callback/
│   │   │   ├── IUniswapV3MintCallback.sol
│   │   │   ├── IUniswapV3SwapCallback.sol
│   │   │   └── IUniswapV3FlashCallback.sol
│   │   ├── pool/
│   │   │   ├── IUniswapV3PoolActions.sol
│   │   │   ├── IUniswapV3PoolDerivedState.sol
│   │   │   ├── IUniswapV3PoolEvents.sol
│   │   │   ├── IUniswapV3PoolImmutables.sol
│   │   │   ├── IUniswapV3PoolOwnerActions.sol
│   │   │   └── IUniswapV3PoolState.sol
│   │   ├── IERC20Minimal.sol
│   │   ├── IUniswapV3Factory.sol
│   │   ├── IUniswapV3Pool.sol
│   │   └── IUniswapV3PoolDeployer.sol
│   ├── libraries/
│   │   ├── BitMath.sol
│   │   ├── FixedPoint96.sol
│   │   ├── FixedPoint128.sol
│   │   ├── FullMath.sol
│   │   ├── LiquidityMath.sol
│   │   ├── LowGasSafeMath.sol
│   │   ├── Oracle.sol
│   │   ├── Position.sol
│   │   ├── SafeCast.sol
│   │   ├── SqrtPriceMath.sol
│   │   ├── SwapMath.sol
│   │   ├── Tick.sol
│   │   ├── TickBitmap.sol
│   │   ├── TickMath.sol
│   │   ├── TransferHelper.sol
│   │   └── UnsafeMath.sol
│   ├── UniswapV3Factory.sol
│   ├── UniswapV3PoolDeployer.sol
│   └── UniswapV3Pool.sol
└── periphery/
    ├── base/
    │   ├── ERC721Permit.sol
    │   ├── LiquidityManagement.sol
    │   ├── Multicall.sol
    │   ├── PeripheryImmutableState.sol
    │   ├── PeripheryPayments.sol
    │   ├── PeripheryPaymentsWithFee.sol
    │   ├── PoolInitializer.sol
    │   └── SelfPermit.sol
    ├── interfaces/
    │   ├── IERC721Permit.sol
    │   ├── INonfungiblePositionManager.sol
    │   ├── IPeripheryImmutableState.sol
    │   ├── IPeripheryPayments.sol
    │   ├── IPeripheryPaymentsWithFee.sol
    │   ├── IPoolInitializer.sol
    │   ├── ISwapRouter.sol
    │   └── IWETH9.sol
    ├── libraries/
    │   ├── BytesLib.sol
    │   ├── CallbackValidation.sol
    │   ├── LiquidityAmounts.sol
    │   ├── Path.sol
    │   ├── PoolAddress.sol
    │   └── PositionKey.sol
    ├── NonfungiblePositionManager.sol
    └── SwapRouter.sol
```

---

## ⚡ Core Contracts & Features

### 1. `UniswapV3Factory`
- Manages the creation of concentrated liquidity AMM pools.
- Enables configurable fee tiers (e.g. 500 = 0.05%, 3000 = 0.30%, 10000 = 1.00%) with custom tick spacings.
- Provides deterministic CREATE2 pool address discovery.

### 2. `UniswapV3Pool`
- **Concentrated Liquidity**: Custom price ranges $[p_a, p_b]$ for capital efficiency.
- **Tick Math & Bitmap**: Efficient tracking of active ticks using 256-bit word bitmaps.
- **Oracle / TWAP**: Built-in observation accumulator tracking `tickCumulative` and `secondsPerLiquidityCumulative`.
- **Flash Loans**: Optimized `flash` function with callback and protocol fee distribution.
- **Protocol Fees**: Protocol fee collection and configuration per fee tier.

### 3. `SwapRouter`
- **Single-Hop Swaps**: `exactInputSingle` and `exactOutputSingle`.
- **Multi-Hop Swaps**: `exactInput` and recursive callback `exactOutput` across arbitrarily chained pools.
- **Safety Checks**: Slippage protection (`amountOutMinimum`, `amountInMaximum`), price limits (`sqrtPriceLimitX96`), and transaction deadlines.

### 4. `NonfungiblePositionManager`
- ERC721 NFT wrapping for Uniswap V3 LP positions.
- Position minting, liquidity additions, liquidity reductions, and fee collection.
- EIP-712 / EIP-2612 permit functionality for gasless approvals.

---

## 🧪 Testing

Run all unit and integration tests:

```bash
forge test
```

Run with detailed execution trace:

```bash
forge test -vvv
```

---

## 🚀 Deployment

```bash
forge script script/DeployUniswapV3.s.sol:DeployUniswapV3 --rpc-url <RPC_URL> --broadcast
```
