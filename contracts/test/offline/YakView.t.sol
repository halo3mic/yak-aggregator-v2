// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.0;

import "../../../lib/ds-test/src/test.sol";
import "./utils/DummyAdapter.sol";
import "hardhat/console.sol";

import "../../adapters/YakUnilikeAdapter.sol";
import "../../interface/IYakAdapter.sol";
import "../../interface/IUnilikePair.sol";
import "../../interface/IUnilikeFactory.sol";
import "../../interface/IYakRegistry.sol";
import "../../interface/IYakView.sol";
import "../../lib/YakViewUtils.sol";

import "../../YakRegistry.sol";
import "../../YakSPRouter.sol";
import "../../YakAdapter.sol";
import "../../YakView.sol";

address constant WAVAX = 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7;

interface CheatCodes {
  function mockCall(address, bytes memory, bytes memory) external;
  function assume(bool) external;
}

contract TestYakView is DSTest {
    using TypeConversion for bytes12;
    using TypeConversion for uint;
    
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
    IYakView yakview;
    mapping(bytes12 => address) dummyAdapters; 

    function setDummyAdapter(
        address from,
        address to, 
        uint multiplier,
        bytes12 blacklistID
    ) public returns (address adapter) {
        adapter = address(
            new DummyAdapter(
                from,
                to,
                multiplier,
                blacklistID
            )
        );
        dummyAdapters[blacklistID] = adapter;
    }

    function setUp() public {
        // Set up some adapters
        /*

            Below are tokens 111, 222, 333, 444 and path paths between them:

            ______________ 1400x_______________
            |_________700x_________            |
            |_________400x_________|  ____5x___|
            |_____2x___   __400x___| |____4x___|
            |          | |         | |         |
          (111) ----> (222) ----> (333) ----> (444)
        
        */

        address[] memory adapters = new address[](5);

        // 111 -> 222: 2x
        adapters[0] = setDummyAdapter(
            address(111),
            address(222),
            2,
            bytes12("111-222-2")
        );
        // 222 -> 333: 400x
        adapters[1] = setDummyAdapter(
            address(222),
            address(333),
            400,
            bytes12("222-333-400")
        );
        // 333 -> 444: 4x
        adapters[2] = setDummyAdapter(
            address(333),
            address(444),
            4,
            bytes12("333-444-4")
        );
        // 333 -> 444: 5x
        adapters[3] = setDummyAdapter(
            address(333),
            address(444),
            5,
            bytes12("333-444-5")
        );
        // Set it to determine gas-price
        adapters[4] = setDummyAdapter(
            WAVAX,
            address(444),
            3,
            bytes12("WAVAX-444-3")
        );

        // Add SPs
        YakSPRouter yaksprouter = new YakSPRouter();
        address[] memory spadapters1 = new address[](1);
        // 111 -> 444: 1400x
        spadapters1[0] = setDummyAdapter(
            address(111),
            address(444),
            1400,
            bytes12("111-444-1400")
        );
        yaksprouter.setSPs(address(111), address(444), spadapters1);

        address[] memory spadapters2 = new address[](2);
        // 111 -> 333: 400x 
        spadapters2[0] = setDummyAdapter(
            address(111),
            address(333),
            400,
            bytes12("111-333-400")
        );
        // 111 -> 333: 700x 
        spadapters2[1] = setDummyAdapter(
            address(111),
            address(333),
            700,
            bytes12("111-333-700")
        );
        yaksprouter.setSPs(address(111), address(333), spadapters2);

        // Set hoppers
        address[] memory hoppers = new address[](2);
        hoppers[0] = address(222);
        hoppers[1] = address(333);

        IYakRegistry yakregistry = new YakRegistry(
            address(yaksprouter),
            adapters,
            hoppers 
        );
        yakview = new YakView(address(yakregistry));
    }

    // findBestAdapterQuote

    function testFindBestAdapterQuote() public {
        uint amountIn = 1;
        QueryResult memory res = yakview.findBestAdapterQuote(
            amountIn, address(111), address(333), bytes("")
        );
        assertEq(res.amountOut, 700 * amountIn);
    }

    function testFindBestAdapterQuoteWithBlacklist() public {
        // Best path between 333 and 444 should be 333-444-5
        uint amountIn = 1;
        address tokenIn = address(333);
        address tokenOut = address(444);
        QueryResult memory res = yakview.findBestAdapterQuote(
            amountIn, 
            tokenIn,
            tokenOut, 
            bytes("")
        );
        assertEq(res.amountOut,  5 * amountIn);
        // Query should offer second best if first is blacklisted
        QueryResult memory resBL = yakview.findBestAdapterQuote(
            amountIn, 
            tokenIn, 
            tokenOut, 
            bytes12("333-444-5").toBytes()
        );
        assertEq(resBL.amountOut, 4 * amountIn);
    }

    // findBestPath
    
    function testFindBestPath(uint amountIn) public {
        // uint amountIn = 200;
        cheats.assume(amountIn > 0);
        cheats.assume(amountIn < 28948022309329048855892746252171976963317496166410141009864396001978282410);
        address tokenIn = address(111);
        address tokenOut = address(444);
        FormattedOffer memory res = yakview.findBestPath(
            amountIn,
            tokenIn,
            tokenOut,
            4,
            0
        );
        assertEq(res.amounts[0], amountIn);
        assertEq(res.amounts[1], amountIn*2);
        assertEq(res.amounts[2], amountIn*2*400);
        assertEq(res.amounts[3], amountIn*2*400*5);
        assertEq(res.path[0], address(111));
        assertEq(res.path[1], address(222));
        assertEq(res.path[2], address(333));
        assertEq(res.path[3], address(444));
        assertEq(res.callTargets[0], dummyAdapters[bytes12("111-222-2")]);
        assertEq(res.callTargets[1], dummyAdapters[bytes12("222-333-400")]);
        assertEq(res.callTargets[2], dummyAdapters[bytes12("333-444-5")]);
    }

    function testFindBestPathWithBlacklist() public {
        uint amountIn = 1;
        address tokenIn = address(111);
        address tokenOut = address(333);

        // Blacklist the the second hop - now the path must go through 111-333-700
        IDummyAdapter(dummyAdapters[bytes12("111-222-2")])
            .setBlacklistID(bytes12("222-333-400"));

        FormattedOffer memory res = yakview.findBestPath(
            amountIn,
            tokenIn,
            tokenOut,
            4,
            0
        );
        assertEq(res.amounts[0], 1);
        assertEq(res.amounts[1], 1*700);
        assertEq(res.path[0], address(111));
        assertEq(res.path[1], address(333));
        assertEq(res.callTargets[0], dummyAdapters[bytes12("111-333-700")]);

        // Restore
        IDummyAdapter(dummyAdapters[bytes12("111-222-2")])
            .setBlacklistID(bytes12("111-222-2"));
    }

    // Increase gas price a lot to make sure the path with the lowest gas cost is chosen
    function testFindBestPathWithGas() public {
        uint amountIn = 1;
        address tokenIn = address(111);
        address tokenOut = address(444);

        FormattedOffer memory res = yakview.findBestPath(
            amountIn,
            tokenIn,
            tokenOut,
            4,
            1
        );
        assertEq(res.amounts[0], amountIn*1);
        assertEq(res.amounts[1], amountIn*1*1400);
        assertEq(res.path[0], address(111));
        assertEq(res.path[1], address(444));
        assertEq(res.callTargets[0], dummyAdapters[bytes12("111-444-1400")]);
    }

}