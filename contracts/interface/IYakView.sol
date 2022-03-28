// SPDX-License-Indentifier: GPL-3-only
pragma solidity >=0.8.0;

import "./IYakAdapter.sol";

struct Query {
    address adapter;
    address tokenIn;
    address tokenOut;
    uint256 amountOut;
}

struct FormattedOffer {
    uint[] amounts;  // TODO: Only amount-out really needed (remove it)
    address[] callTargets;
    address[] fundTargets;
    address[] path;
    bytes32[] extra;
}

struct Trade {
    uint amountIn;
    uint amountOut;
    address[] path;
    address[] adapters;
}

interface IYakView {

    function findBestAdapterQuote(
        uint _amountIn, 
        address _tokenIn, 
        address _tokenOut, 
        bytes memory _blacklisted
    ) external view returns (QueryResult memory);

    function findBestPath(
        uint256 _amountIn, 
        address _tokenIn, 
        address _tokenOut, 
        uint _maxSteps,
        uint _gasPrice
    ) external view returns (FormattedOffer memory);

}