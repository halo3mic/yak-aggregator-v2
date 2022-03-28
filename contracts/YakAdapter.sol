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
                           ╘╠╠╠╠╠╠╠╠╠╠  ╬╠╠╠╠╠╠╠╩                            
                            ╘╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╩                              
                              ╘╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╩                               
                               ╘╬╠╠╠╠╠╠╠╠╠╠╠╠╩                                 
                                ╘╠╠╠╠╠╠╠╠╠╠╠╩                                
                                 ╠╠╠╠╠╠╠╠╠╠╠                                  
                                 ╠╠╠╠╠╠╠╠╠╠╠                                  
                                 ╘╠╠╠╠╠╠╠╠╠╩                                  
                                  ╘╠╠╠╠╠╠╠╩

*******************************************************************************/

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/IYakAdapter.sol";
import "./lib/Recoverable.sol";

abstract contract YakAdapter is IYakAdapter, Ownable, Recoverable {
    using SafeERC20 for IERC20;

    bytes32 immutable TYPE;

    uint public swapGasEstimate;
    string public name;

    constructor(
        bytes32 _type,
        string memory _name,
        uint _swapGasEstimate
    ) {
        setSwapGasEstimate(_swapGasEstimate);
        setName(_name);
        TYPE = _type;
    }

    receive() external payable {}

    function query(
        uint _amountIn, 
        address _tokenIn, 
        address _tokenOut
    ) external view returns (QueryResult memory) {
        return _query(
            _amountIn, 
            _tokenIn, 
            _tokenOut
        );
    }

    /**
     * Execute a swap from token to token assuming this contract already holds input tokens
     * @notice Interact through the router
     * @param _amountIn input amount in starting token
     * @param _amountOut amount out in ending token
     * @param _fromToken ERC20 token being sold
     * @param _toToken ERC20 token being bought
     * @param _to address where swapped funds should be sent to
     */
    function swap(
        uint _amountIn, 
        uint _amountOut,
        address _fromToken, 
        address _toToken, 
        address _to,
        bytes32 _extra
    ) external {
        _swap(_amountIn, _amountOut, _fromToken, _toToken, _to, _extra);
        emit YakAdapterSwap(
            _fromToken, 
            _toToken,
            _amountIn, 
            _amountOut 
        );
    }

    function setSwapGasEstimate(uint _estimate) public onlyOwner {
        swapGasEstimate = _estimate;
        emit UpdatedGasEstimate(address(this), _estimate);
    }

    function setName(string memory _name) public onlyOwner {
        name = _name;
        emit UpdatedName(_name);
    }

    /**
     * @notice Internal implementation of a swap
     * @dev Must return tokens to address(this)
     * @dev Wrapping is handled external to this function
     * @param _amountIn amount being sold
     * @param _amountOut amount being bought
     * @param _fromToken ERC20 token being sold
     * @param _toToken ERC20 token being bought
     * @param _to Where recieved tokens are sent to
     */
    function _swap(
        uint _amountIn, 
        uint _amountOut, 
        address _fromToken, 
        address _toToken, 
        address _to,
        bytes32 _extra
    ) internal virtual;

    function _query(
        uint _amountIn,
        address _tokenIn, 
        address _tokenOut
    ) internal virtual view returns (QueryResult memory);

}