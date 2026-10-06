// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../core/interfaces/IERC20Minimal.sol";

/// @title Interface for WETH9
interface IWETH9 is IERC20Minimal {
    function deposit() external payable;
    function withdraw(uint256) external;
}
