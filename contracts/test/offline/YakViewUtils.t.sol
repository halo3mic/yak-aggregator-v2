// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.0;

import "../../../lib/ds-test/src/test.sol";
import "hardhat/console.sol";

import "../../lib/YakViewUtils.sol";
import "../../lib/TypeConversion.sol";
import "../../interface/IYakView.sol";
import "../../interface/IYakAdapter.sol";

contract TestYakViewUtils is DSTest {
    using YakViewUtils for Offer;
    using TypeConversion for bytes12;
    using TypeConversion for bytes32;
    using TypeConversion for address;
    using TypeConversion for uint;
    using TypeConversion for bytes;

    function testBytes12Include() public {
        bytes memory bytesArray = bytes.concat(
            bytes12("ola").toBytes(),
            bytes12("fren").toBytes(),
            bytes12("laptop").toBytes(),
            bytes12("fun").toBytes()
        );
        assert(YakViewUtils.includes(bytesArray, bytes12("laptop")));
        assert(!YakViewUtils.includes(bytesArray, bytes12("vola")));
    }

    function testInit() public {
        uint amountIn = 12 ether;
        address tokenIn = address(123);
        Offer memory offer = YakViewUtils.newOffer(amountIn, tokenIn);
        assert(offer.amounts.toUint(32) == amountIn);
        assert(offer.path.toAddress(32) == tokenIn);
        assert(offer.callTargets.length == 0);
        assert(offer.fundTargets.length == 0);
        assert(offer.blacklisted.length == 0);
        assert(offer.extra.length == 0);
        assert(offer.gasEstimate == 0);
    }

    function testCloning() public {
        Offer memory orgOffer = Offer({
            blacklisted: bytes12("blabla").toBytes(),
            extra: bytes32("woop-woop").toBytes(),
            fundTargets: address(345).toBytes(),
            callTargets: address(234).toBytes(),
            amounts: uint(1234).toBytes(),
            path: address(123).toBytes(),
            gasEstimate: 323e3
        });
        Offer memory clonedOffer = orgOffer.clone();
        assert(keccak256(clonedOffer.blacklisted) == keccak256(orgOffer.blacklisted));
        assert(keccak256(clonedOffer.extra) == keccak256(orgOffer.extra));
        assert(keccak256(clonedOffer.fundTargets) == keccak256(orgOffer.fundTargets));
        assert(keccak256(clonedOffer.callTargets) == keccak256(orgOffer.callTargets));
        assert(keccak256(clonedOffer.amounts) == keccak256(orgOffer.amounts));
        assert(keccak256(clonedOffer.path) == keccak256(orgOffer.path));
        assert(clonedOffer.gasEstimate == clonedOffer.gasEstimate);
    }

    function testAddingToOffer() public {
        Offer memory offer = Offer({
            blacklisted: bytes12("blabla").toBytes(),
            extra: bytes32("woop-woop").toBytes(),
            fundTargets: address(345).toBytes(),
            callTargets: address(234).toBytes(),
            amounts: uint(7777).toBytes(),
            path: address(123).toBytes(),
            gasEstimate: 1e5
        });
        Offer memory offerClone = offer.clone();
        QueryResult memory queryResult = QueryResult({
            amountOut: 8888,
            extra: bytes32("rsk-rsk"),
            callTarget: address(999),
            fundTarget: address(112),
            blacklistID: bytes12("ha")
        });
        uint gasEstimate = 8.2e5;
        address tokenOut = address(234);
        offer.add(
            queryResult,
            gasEstimate,
            tokenOut
        );
        assert(offer.gasEstimate == 9.2e5);
        assert(keccak256(offer.path) == keccak256(bytes.concat(
            offerClone.path, tokenOut.toBytes() 
        )));
        assert(keccak256(offer.blacklisted) == keccak256(bytes.concat(
            offerClone.blacklisted, queryResult.blacklistID.toBytes() 
        )));
        assert(keccak256(offer.extra) == keccak256(bytes.concat(
            offerClone.extra, queryResult.extra.toBytes() 
        )));
        assert(keccak256(offer.fundTargets) == keccak256(bytes.concat(
            offerClone.fundTargets, queryResult.fundTarget.toBytes() 
        )));
        assert(keccak256(offer.callTargets) == keccak256(bytes.concat(
            offerClone.callTargets, queryResult.callTarget.toBytes() 
        )));
        assert(keccak256(offer.amounts) == keccak256(bytes.concat(
            offerClone.amounts, queryResult.amountOut.toBytes() 
        )));
    }

    function testRetrievingTknNAmountOut() public {
        Offer memory offer = Offer({
            blacklisted: bytes12("blabla").toBytes(),
            extra: bytes32("woop-woop").toBytes(),
            fundTargets: address(345).toBytes(),
            callTargets: address(234).toBytes(),
            amounts: uint(7777).toBytes(),
            path: address(123).toBytes(),
            gasEstimate: 1e5
        });
        QueryResult memory queryResult = QueryResult({
            amountOut: 8888,
            extra: bytes32("rsk-rsk"),
            callTarget: address(999),
            fundTarget: address(112),
            blacklistID: bytes12("ha")
        });
        uint gasEstimate = 8.2e5;
        address tokenOut = address(234);
        offer.add(
            queryResult,
            gasEstimate,
            tokenOut
        );
        assert(offer.getTokenOut() == tokenOut);
        assert(offer.getAmountOut() == queryResult.amountOut);
    }

    function testFormatting() public {
        Offer memory offer = Offer({
            blacklisted: bytes12("blabla").toBytes(),
            extra: bytes32("woop-woop").toBytes(),
            fundTargets: address(345).toBytes(),
            callTargets: address(234).toBytes(),
            amounts: uint(7777).toBytes(),
            path: address(123).toBytes(),
            gasEstimate: 1e5
        });
        FormattedOffer memory fOffer = offer.format();
        
        assert(fOffer.amounts[0] == 7777);
        assert(fOffer.callTargets[0] == address(234));
        assert(fOffer.fundTargets[0] == address(345));
        assert(fOffer.path[0] == address(123));
        assert(fOffer.extra[0] == bytes32("woop-woop"));
    }


}