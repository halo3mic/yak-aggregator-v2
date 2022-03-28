/*******************************************************************************

             ╔                                                 ╗         
           ╔╠╩                                                 ╘╠╕ 
          ╔╠╠                                                   ╠╠╕       
          ╠╠╠╕                                                 ╒╠╠╠             
          ╘╠╠╠╠╕                                             ╒╠╠╠╠╩       
           ╘╠╠╠╠╠╠╕                                       ╒╠╠╠╠╠╠╩            
            ╘╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╕       ╒╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╩            
              ╘╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╕    ╒╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╩           
                ╘╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╕  ╒╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╩                   
                           ╘╠╠╠╠╠╠╠╠╠╠  ╬╠╠╠╠╠╠╠╠╩                            
                            ╘╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╩                              
                              ╘╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠                               
                               ╘╬╠╠╠╠╠╠╠╠╠╠╠╠╩                                 
                                ╘╠╠╠╠╠╠╠╠╠╠╠╩                                
                                 ╠╠╠╠╠╠╠╠╠╠╠                                  
                                 ╠╠╠╠╠╠╠╠╠╠╠                                  
                                 ╘╠╠╠╠╠╠╠╠╠╩                                  
                                  ╘╠╠╠╠╠╠╠╩

*******************************************************************************/

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.0;

import "../interface/IUnilikeFactory.sol";
import "../interface/IUnilikePair.sol";
import "../lib/TypeConversion.sol";
import "../YakAdapter.sol";

import "hardhat/console.sol";

contract YakUnilikeAdapter is YakAdapter {
    using TypeConversion for address;
    using TypeConversion for bytes32;

    uint internal constant FEE_DENOMINATOR = 1e3;
    uint internal immutable FEE_COMPLIMENT;
    address internal immutable FACTORY;

    constructor(
        string memory _name, 
        address _factory, 
        uint _fee,
        uint _swapGasEstimate
    ) YakAdapter("Unilike", _name, _swapGasEstimate) {
        FEE_COMPLIMENT = 1e3 - _fee;
        FACTORY = _factory;
    }

    function _getAmountOut(
        uint _amountIn, 
        uint _reserveIn, 
        uint _reserveOut
    ) internal view returns (uint amountOut) {
        uint amountInWithFee = _amountIn * FEE_COMPLIMENT;
        uint numerator = amountInWithFee * _reserveOut;
        uint denominator = _reserveIn * FEE_DENOMINATOR + amountInWithFee;
        amountOut = numerator / denominator;
    }

    function _query(
        uint _amountIn, 
        address _tokenIn, 
        address _tokenOut
    ) internal override view returns (QueryResult memory result) {
        if (_tokenIn != _tokenOut &&  _amountIn!=0) {
            address pair = IUnilikeFactory(FACTORY).getPair(_tokenIn, _tokenOut);
            if (pair != address(0)) {
                (uint r0, uint r1, ) = IUnilikePair(pair).getReserves();
                (uint reserveIn, uint reserveOut) = _tokenIn < _tokenOut 
                    ? (r0, r1) 
                    : (r1, r0);
                if (reserveIn > 0 && reserveOut > 0) {
                    uint amountOut = _getAmountOut(
                        _amountIn, 
                        reserveIn, 
                        reserveOut
                    );
                    console.log(pair);
                    console.logBytes32(pair.toBytes12());
                    console.logBytes32(pair.toBytes32());
                    result = QueryResult({
                        blacklistID: pair.toBytes12(),
                        callTarget: address(this),
                        extra: pair.toBytes32(),
                        amountOut: amountOut,
                        fundTarget: pair
                    });
                }
            }
        }
    }

    function _swap(
        uint, 
        uint _amountOut, 
        address _tokenIn, 
        address _tokenOut, 
        address _to,
        bytes32 _extra
    ) internal override {
        (uint amount0Out, uint amount1Out) = (_tokenIn < _tokenOut) 
            ? (uint(0), _amountOut) 
            : (_amountOut, uint(0));
        IUnilikePair(_extra.toAddress()).swap(
            amount0Out, 
            amount1Out,
            _to, 
            new bytes(0)
        );
    }

    
}