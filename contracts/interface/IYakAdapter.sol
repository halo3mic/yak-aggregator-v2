// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.0;

/**
    * @param amountOut Amount of tokens returned
    * @param extra Extra data to be sent to the adapter when swapping
    * @param callTarget Which contract should be called next
    * @param fundTarget Where tokens should be sent
    * @param blacklistID ID of the pool or pool direction
    * @dev Extra data can be used to indentify exact pool/adapter to swap to
    * @dev blacklistID is used to identify the pool/pool-option that shouldn't 
    *      be used again in the following swaps
**/
struct QueryResult {
    uint amountOut;
    bytes32 extra;
    address callTarget;
    address fundTarget;
    bytes12 blacklistID;
}

interface IYakAdapter {

    event YakAdapterSwap(
        address indexed tokenFrom, 
        address indexed tokenTo, 
        uint amountIn, 
        uint amountOut
    );

    event UpdatedGasEstimate(
        address indexed adapter,
        uint newEstimate
    );

    event UpdatedName(
        string newName
    );

    function name() external view returns (string memory);
    function swapGasEstimate() external view returns (uint);
    function swap(
        uint256, 
        uint256, 
        address, 
        address, 
        address,
        bytes32
    ) external;
    function query(
        uint256, 
        address, 
        address
    ) external view returns (QueryResult memory);

}