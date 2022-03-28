// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.0;

interface IYakRegistry {
    function getHoppers() external view returns (address[] memory);
    function getSources() external view returns (address[] memory);
    function getSPRouter() external view returns (address);
}