// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IUnilikePair {
    function getReserves() external view returns (uint112,uint112,uint32);
    function swap(uint,uint,address,bytes calldata) external;
}