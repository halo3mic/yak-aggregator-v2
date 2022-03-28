// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.0;

interface IYakSPRouter {
    function getSPs(
        address _tknFrom, 
        address _tknTo
    ) external view returns (address[] memory);
}