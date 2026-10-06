// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IPeripheryPayments.sol";

/// @title Periphery Payments with Fee
/// @notice Functions to ease transfers of ETH and ERC20 tokens with fee on transfer options
interface IPeripheryPaymentsWithFee is IPeripheryPayments {
    function unwrapWETH9WithFee(
        uint256 amountMinimum,
        address recipient,
        uint256 feeBips,
        address feeRecipient
    ) external payable;

    function sweepTokenWithFee(
        address token,
        uint256 amountMinimum,
        address recipient,
        uint256 feeBips,
        address feeRecipient
    ) external payable;
}
