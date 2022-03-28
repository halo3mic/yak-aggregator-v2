// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.0;

import "../../../YakAdapter.sol";

interface IDummyAdapter {
    function setBlacklistID(bytes12) external;
}

contract DummyAdapter is YakAdapter {
    
    bytes12 public blacklistID;
    address immutable tokenFrom;
    address immutable tokenTo;
    uint immutable multiplier;

    constructor(
        address _tknFrom, 
        address _tknTo,
        uint _multiplier,
        bytes12 _blacklistID
    ) YakAdapter("Dummy", "Dummy", 0) {
        blacklistID = _blacklistID;
        multiplier = _multiplier;
        tokenFrom = _tknFrom;
        tokenTo = _tknTo;
        swapGasEstimate = 1e5;
    }

    function setBlacklistID(bytes12 _newID) public {
        blacklistID = _newID;
    }

    function _query(
        uint _amountIn, 
        address _tokenIn, 
        address _tokenOut
    ) internal override view returns (QueryResult memory res) {
        if (_tokenIn == tokenFrom && _tokenOut == tokenTo) {
            res = QueryResult({
                fundTarget: address(this),
                callTarget: address(this),
                amountOut: multiplier * _amountIn,
                blacklistID: blacklistID,
                extra: ""  // Random
            });
        }
    }

    function _swap(
        uint, 
        uint _amountOut, 
        address _tokenIn, 
        address _tokenOut, 
        address _to,
        bytes32 _extra
    ) internal override {}

}