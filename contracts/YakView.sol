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

// SPDX-License-Indentifier: GPL-3-only
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/IYakRegistry.sol";
import "./interface/IYakSPRouter.sol";
import "./interface/IYakAdapter.sol";
import "./interface/IYakView.sol";
import { Offer, YakViewUtils } from  "./lib/YakViewUtils.sol";

import "hardhat/console.sol";

contract YakView is Ownable, IYakView {
    using YakViewUtils for Offer;

    // TODO: Move to registy
    address WAVAX = 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7;
    address yakregistry;

    constructor(address _yakregistry) {
        yakregistry = _yakregistry;
    }

    function findBestAdapterQuoteForSources(
        uint _amountIn, 
        address _tokenIn, 
        address _tokenOut, 
        bytes memory _blacklisted, 
        address[] memory _sources
    ) internal view returns (QueryResult memory bestQuery) {
      for (uint8 i; i<_sources.length; i++) {
          address _source = _sources[i];
          QueryResult memory res = IYakAdapter(_source).query(
              _amountIn, 
              _tokenIn, 
              _tokenOut
          );
          if (
            res.amountOut>bestQuery.amountOut 
            && !YakViewUtils.includes(_blacklisted, res.blacklistID)
          ) {
              bestQuery = res;
          }
      }
    }

    function findBestAdapterQuote(
        uint _amountIn, 
        address _tokenIn, 
        address _tokenOut, 
        bytes memory _blacklisted
    ) public view returns (QueryResult memory) {
        QueryResult memory res0 = findBestAdapterQuoteForSources(
          _amountIn, 
          _tokenIn, 
          _tokenOut, 
          _blacklisted, 
          IYakRegistry(yakregistry).getSources()
        );
        address[] memory sourcesSP = IYakSPRouter(
          IYakRegistry(yakregistry).getSPRouter()
        ).getSPs(_tokenIn, _tokenOut);
        QueryResult memory res1 = findBestAdapterQuoteForSources(
          _amountIn, 
          _tokenIn, 
          _tokenOut, 
          _blacklisted, 
          sourcesSP
        );
        return res1.amountOut > res0.amountOut ? res1 : res0;
    }

    function getGasPriceInExitTkn(uint _gasPrice, address _tokenOut) internal view returns (uint) {
        // Find the market price between AVAX and token-out and express gas price in token-out currency
        // TODO: Explain better choice for 1 AVAX
        FormattedOffer memory gasQuery = findBestPath(1e18, WAVAX, _tokenOut, 2, 0);  // Avoid low-liquidity price appreciation
        // Include safety check if no 2-step path between WAVAX and tokenOut is found
        if (gasQuery.path.length != 0) {
            // TODO: explain extending precision
            // Leave result !!!nWei!!! to preserve digits for assets with low decimal places
            return gasQuery.amounts[gasQuery.amounts.length-1]*_gasPrice/1e9;
        }
    }

     /**
     * Return path with best returns between two tokens
     * Takes gas-cost into account
     */
    function findBestPath(
        uint256 _amountIn, 
        address _tokenIn, 
        address _tokenOut, 
        uint _maxSteps,
        uint _gasPrice
    ) public view returns (FormattedOffer memory) {
        require(_maxSteps>0 && _maxSteps<5, "YakRouter: Invalid max-steps");
        Offer memory offer = YakViewUtils.newOffer(_amountIn, _tokenIn);
        uint gasPriceInExitTkn = _gasPrice > 0 
            ? getGasPriceInExitTkn(_gasPrice, _tokenOut) 
            : 0;
        console.log("gas-price", gasPriceInExitTkn);
        offer = _findBestPath(
            _amountIn, 
            _tokenIn, 
            _tokenOut, 
            _maxSteps,
            offer, 
            gasPriceInExitTkn
        );
        // If no paths are found return empty struct
        if (offer.callTargets.length > 0) {
            return offer.format();
        }
    } 

    function _findBestPath(
        uint256 _amountIn, 
        address _tokenIn, 
        address _tokenOut, 
        uint _maxSteps,
        Offer memory _queries, 
        uint _tknOutPriceNwei
    ) internal view returns (Offer memory) {
        // TODO: Can Offer struct be moved from IYakView to YakViewUtils as a global struct?
        // TODO: Later move hoppers in common storage - make it global variable
        address[] memory hoppers = IYakRegistry(yakregistry).getHoppers();
        Offer memory bestOption = _queries.clone();
        uint bestAmountOut;
        // TODO: Can this part be moved below?
        // First check if there is a path directly from tokenIn to tokenOut
        QueryResult memory queryDirect = findBestAdapterQuote(
          _amountIn, 
          _tokenIn, 
          _tokenOut, 
          _queries.blacklisted
        );
        if (queryDirect.amountOut != 0) {
            console.log(queryDirect.callTarget);
            uint gasEstimate = IYakAdapter(queryDirect.callTarget).swapGasEstimate();
            console.log(gasEstimate);
            bestOption.add(queryDirect, gasEstimate, _tokenOut);
            bestAmountOut = queryDirect.amountOut;
        }
        // Only check the rest if they would go beyond step limit (Need at least 2 more steps)
        if (_maxSteps>1 && _queries.callTargets.length/32<=_maxSteps-2) {
            // Check for paths that pass through trusted tokens
            for (uint i=0; i < hoppers.length; i++) {
                // TODO: Add `|| _tokenOut == hoppers[i]` below?
                if (_tokenIn == hoppers[i]) {
                    continue;
                }
                // Loop through all adapters to find the best one for swapping tokenIn for one of the trusted tokens
                QueryResult memory bestSwap = findBestAdapterQuote(
                    _amountIn, 
                    _tokenIn, 
                    hoppers[i],
                    _queries.blacklisted
                );
                if (bestSwap.amountOut == 0) {
                    continue;
                }
                // Explore options that connect the current path to the tokenOut
                Offer memory newOffer = _queries.clone();
                uint gasEstimate = IYakAdapter(bestSwap.callTarget).swapGasEstimate();
                newOffer.add(bestSwap, gasEstimate, hoppers[i]);
                newOffer = _findBestPath(
                    bestSwap.amountOut, 
                    hoppers[i], 
                    _tokenOut, 
                    _maxSteps, 
                    newOffer, 
                    _tknOutPriceNwei
                );
                address tokenOut = newOffer.getTokenOut();
                uint256 amountOut = newOffer.getAmountOut();
                // Check that the last token in the path is the tokenOut and update the new best option if neccesary
                if (_tokenOut == tokenOut && amountOut > bestAmountOut) {
                    console.log("best-offer-gas", bestOption.gasEstimate, bestOption.getAmountOut());
                    console.log("new-offer-gas", newOffer.gasEstimate, amountOut);
                    if (newOffer.gasEstimate > bestOption.gasEstimate) {
                        uint gasCostDiff = _tknOutPriceNwei 
                            * (newOffer.gasEstimate - bestOption.gasEstimate) 
                            / 1e9;
                        uint priceDiff = amountOut - bestAmountOut;
                        console.log(_tknOutPriceNwei, priceDiff, gasCostDiff);
                        if (gasCostDiff > priceDiff) { continue; }
                    }
                    bestAmountOut = amountOut;
                    bestOption = newOffer;
                }
            }
        }
        return bestOption;   
    }

}