// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Periphery Payments
/// @notice Functions to ease transfers of ETH and ERC20 tokens
interface IPeripheryPayments {
    function unwrapWETH9(uint256 amountMinimum, address recipient) external payable;
    function refundETH() external payable;
    function sweepToken(
        address token,
        uint256 amountMinimum,
        address recipient
    ) external payable;
}
