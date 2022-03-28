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

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/IYakAdapter.sol";
import "./lib/TypeConversion.sol";

// TODO: Put this in registry??

contract YakSPRouter is Ownable {
    using TypeConversion for bytes32;

    mapping(address => mapping(address => address[])) internal _SPMap;

    function setSPs(
        address _tknFrom, 
        address _tknTo,
        address[] calldata _sps
    ) external onlyOwner {
        _SPMap[_tknFrom][_tknTo] = _sps;
    }

    function pushSP(
        address _tknFrom, 
        address _tknTo,
        address[] calldata _sps
    ) external onlyOwner {
        _SPMap[_tknFrom][_tknTo] = _sps;
    }

    // Reverts with out-of-bounds if the index is out of bounds
    // Only accepts sorted indices
    // Its cheaper to use single-use one for removing one element 
    function removeSPs(
        address _tknFrom, 
        address _tknTo,
        uint[] calldata _indices
    ) external onlyOwner {
        uint elements = _SPMap[_tknFrom][_tknTo].length;
        uint lastIndex = _indices[0]+1;
        for (uint i; i < _indices.length; i++) {
            require(lastIndex > _indices[i], "Indices must be sorted desc");
            if (elements - 1 > _indices[i]) {
                _SPMap[_tknFrom][_tknTo][_indices[i]] = _SPMap[_tknFrom][_tknTo][elements-1];
            } else if (elements - 1 < _indices[i]) {
                revert("Out of bounds");
            }
            _SPMap[_tknFrom][_tknTo].pop();
            elements -= 1;
            lastIndex = _indices[i];
        }
    }

    function removeSP(
        address _tknFrom, 
        address _tknTo,
        uint _index
    ) external onlyOwner {
        uint elements = _SPMap[_tknFrom][_tknTo].length;
        if (elements - 1 > _index) {
            _SPMap[_tknFrom][_tknTo][_index] = _SPMap[_tknFrom][_tknTo][elements-1];
        }
        _SPMap[_tknFrom][_tknTo].pop();
    }

    function getSPs(
        address _tknFrom, 
        address _tknTo
    ) external view returns (address[] memory) {
        return _SPMap[_tknFrom][_tknTo];
    }
    
}