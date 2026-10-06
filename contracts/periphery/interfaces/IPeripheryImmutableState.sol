// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Immutable state
/// @notice Functions that return immutable state of the router/periphery contracts
interface IPeripheryImmutableState {
    function factory() external view returns (address);
    function WETH9() external view returns (address);
}
