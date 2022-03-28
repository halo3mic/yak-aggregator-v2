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

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/IYakRegistry.sol";

contract YakRegistry is Ownable, IYakRegistry {

    address internal sprouter;  // Single-Pool router
    address[] internal sources; // Liquidity sources (adapters)
    address[] internal hoppers; // Intermediary tokens
    
    constructor(
        address _sprouter,
        address[] memory _sources, 
        address[] memory _hoppers
    ) {
        sprouter = _sprouter;
        sources = _sources;
        hoppers = _hoppers;
    }

    function setSPRouter(address _sprouter) external onlyOwner {
        sprouter = _sprouter;
    }

    function setSources(address[] calldata _sources) external onlyOwner {
        sources = _sources;
    }

    function setHoppers(address[] calldata _hoppers) external onlyOwner {
        hoppers = _hoppers;
    }

    function getSPRouter() external view returns (address) {
        return sprouter;
    }

    function getSources() external view returns (address[] memory) {
        return sources;
    }

    function getHoppers() external view returns (address[] memory) {
        return hoppers;
    }

}