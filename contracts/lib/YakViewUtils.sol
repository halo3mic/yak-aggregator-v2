// SPDX-License-Indentifier: GPL-3-only
pragma solidity >=0.8.0;

import { FormattedOffer } from "../interface/IYakView.sol";
import { QueryResult } from "../interface/IYakAdapter.sol";
import "./TypeConversion.sol";

struct Offer {
    uint gasEstimate;
    bytes callTargets;
    bytes fundTargets;
    bytes blacklisted;
    bytes amounts;
    bytes extra;
    bytes path;
}

library YakViewUtils {

    using TypeConversion for address;
    using TypeConversion for bytes;
    using TypeConversion for uint;
    using TypeConversion for bytes32;
    using TypeConversion for bytes12;

    // TODO: Make more efficient
    // TODO: Does this even belong here?
    function includes(
      bytes memory a, 
      bytes12 e
    ) internal pure returns (bool r) {
        for (uint i=0; i < a.length/32; i++) {
            if (e == a.toBytes12(i*32 + 32)) {
                return true;
            }
        }
    }

    // Use lib for maniuplating the offers

    function newOffer(
        uint _amountIn,
        address _tokenIn
    ) internal pure returns (Offer memory offer) {
        offer.amounts = _amountIn.toBytes();
        offer.path = _tokenIn.toBytes();
    }

    /**
     * Makes a deep copy of OfferWithGas struct
     */
    function clone(
        Offer memory _offer
    ) internal pure returns (Offer memory) {
        return Offer({
            gasEstimate: _offer.gasEstimate,
            blacklisted: _offer.blacklisted,
            fundTargets: _offer.fundTargets,
            callTargets: _offer.callTargets,
            amounts: _offer.amounts,
            extra: _offer.extra,
            path: _offer.path
        });
    }

    /**
     * Appends Query elements to Offer struct
     */
    function add(
        Offer memory _offer, 
        QueryResult memory _result,
        uint _gasEstimate,
        address _tokenOut
    ) internal pure {
        _offer.blacklisted = bytes.concat(_offer.blacklisted, _result.blacklistID.toBytes());
        _offer.callTargets = bytes.concat(_offer.callTargets, _result.callTarget.toBytes());
        _offer.fundTargets = bytes.concat(_offer.fundTargets, _result.fundTarget.toBytes());
        _offer.amounts = bytes.concat(_offer.amounts, _result.amountOut.toBytes());
        _offer.extra = bytes.concat(_offer.extra, _result.extra.toBytes());
        _offer.path = bytes.concat(_offer.path, _tokenOut.toBytes());
        _offer.gasEstimate += _gasEstimate;
    }

    function getTokenOut(
        Offer memory _offer
    ) internal pure returns (address tokenOut) {
        tokenOut = _offer.path.toAddress(_offer.path.length);  // Last 32 bytes
    }

    function getAmountOut(
        Offer memory _offer
    ) internal pure returns (uint amountOut) {
        amountOut = _offer.amounts.toUint(_offer.path.length);  // Last 32 bytes
    }

    /**
     * Formats elements in the Offer object from byte-arrays to integers and addresses
     */
    function format(
        Offer memory _offer
    ) internal pure returns (FormattedOffer memory) {
        return FormattedOffer({
            callTargets: _offer.callTargets.toAddresses(),
            fundTargets: _offer.fundTargets.toAddresses(),
            amounts: _offer.amounts.toUints(),
            extra: _offer.extra.toBytes32s(),
            path: _offer.path.toAddresses()
        });
    }

}