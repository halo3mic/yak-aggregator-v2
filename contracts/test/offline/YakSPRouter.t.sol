// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.0;

import { DynamicArray } from "../utils/ArrayUtils.sol";
import "../../../lib/ds-test/src/test.sol";
import "../../YakSPRouter.sol";
import "hardhat/console.sol";

contract SPRouterTest is DSTest {
    using DynamicArray for address[];
    using DynamicArray for uint[];

    struct SupportedTokens {
        address tkn0;
        address tkn1;
        address[] adapters;
    }
    
    YakSPRouter spRouter;
    SupportedTokens[] supportedTokens;

    function setUp() public {
        spRouter = new YakSPRouter();

        supportedTokens.push(SupportedTokens(
            0x59414b3089ce2AF0010e7523Dea7E2b35d776ec7, 
            0xdDAaAD7366B455AfF8E7c82940C43CEB5829B604,
            (new address[](1))
                .append(0xC3BEe4623A7aE76Ca0805078e98069DEbF79E826)
        ));
        supportedTokens.push(SupportedTokens(
            0xdDAaAD7366B455AfF8E7c82940C43CEB5829B604, 
            0x59414b3089ce2AF0010e7523Dea7E2b35d776ec7,
            (new address[](1))
                .append(0xC3BEe4623A7aE76Ca0805078e98069DEbF79E826)
        ));
        supportedTokens.push(SupportedTokens(
            0xDC42728B0eA910349ed3c6e1c9Dc06b5FB591f98, 
            0x1C20E891Bab6b1727d14Da358FAe2984Ed9B59EB,
            (new address[](1))
                .append(0x10EF2400d1a7f64017e80669B218f30ca9816e22)
        ));
        supportedTokens.push(SupportedTokens(
            0xDC42728B0eA910349ed3c6e1c9Dc06b5FB591f98, 
            0xde3A24028580884448a5397872046a019649b084,
            (new address[](1))
                .append(0x10EF2400d1a7f64017e80669B218f30ca9816e22)
        ));
        supportedTokens.push(SupportedTokens(
            0xDC42728B0eA910349ed3c6e1c9Dc06b5FB591f98, 
            0x130966628846BFd36ff31a822705796e8cb8C18D,
            (new address[](1))
                .append(0x5302AedD1b484fBe70EFd91Ca0C40785f5B4A69d)
        ));
        supportedTokens.push(SupportedTokens(
            0xDC42728B0eA910349ed3c6e1c9Dc06b5FB591f98, 
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70,
            (new address[](1))
                .append(0x5302AedD1b484fBe70EFd91Ca0C40785f5B4A69d)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xDC42728B0eA910349ed3c6e1c9Dc06b5FB591f98, 
            0x4fbf0429599460D327BD5F55625E30E4fC066095,
            (new address[](1))
                .append(0x5302AedD1b484fBe70EFd91Ca0C40785f5B4A69d)
        ));
        supportedTokens.push(SupportedTokens(
            0x1C20E891Bab6b1727d14Da358FAe2984Ed9B59EB, 
            0xDC42728B0eA910349ed3c6e1c9Dc06b5FB591f98,
            (new address[](1))
                .append(0x10EF2400d1a7f64017e80669B218f30ca9816e22)
        ));
        supportedTokens.push(SupportedTokens(
            0x1C20E891Bab6b1727d14Da358FAe2984Ed9B59EB, 
            0xde3A24028580884448a5397872046a019649b084,
            (new address[](1))
                .append(0x10EF2400d1a7f64017e80669B218f30ca9816e22)
        ));
        supportedTokens.push(SupportedTokens(
            0x1C20E891Bab6b1727d14Da358FAe2984Ed9B59EB, 
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664,
            (new address[](1))
                .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
        ));
        supportedTokens.push(SupportedTokens(
            0x1C20E891Bab6b1727d14Da358FAe2984Ed9B59EB, 
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118,
            (new address[](1))
                .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
        ));
        supportedTokens.push(SupportedTokens(
            0x1C20E891Bab6b1727d14Da358FAe2984Ed9B59EB, 
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70,
            (new address[](1))
                .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
        ));
        supportedTokens.push(SupportedTokens(
            0xde3A24028580884448a5397872046a019649b084, 
            0xDC42728B0eA910349ed3c6e1c9Dc06b5FB591f98,
            (new address[](1))
                .append(0x10EF2400d1a7f64017e80669B218f30ca9816e22)
        ));
        supportedTokens.push(SupportedTokens(
            0xde3A24028580884448a5397872046a019649b084, 
            0x1C20E891Bab6b1727d14Da358FAe2984Ed9B59EB,
            (new address[](1))
                .append(0x10EF2400d1a7f64017e80669B218f30ca9816e22)
        ));
        supportedTokens.push(SupportedTokens(
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664, 
            0x1C20E891Bab6b1727d14Da358FAe2984Ed9B59EB,
            (new address[](1))
                .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
        ));
        supportedTokens.push(SupportedTokens(
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664, 
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118,
            (new address[](5))
                .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
                    .append(0x77fc17D927eBcEaEA2c4704BaB1AEebB0547ea42)
                    .append(0xd0f6e66113A6D6Cca238371948F4Ce2893D62881)
                    .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
                    .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
        supportedTokens.push(SupportedTokens(
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664, 
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70,
            (new address[](5))
                .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
                    .append(0x55deBF770FC61C8DD9DE4F4A2d90606F3e906B2e)
                    .append(0x77fc17D927eBcEaEA2c4704BaB1AEebB0547ea42)
                    .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
                    .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
        supportedTokens.push(SupportedTokens(
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664, 
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664,
            (new address[](1))
                .append(0xc362eaFAa85728893a0d1084D3e2Ff7ffDF2fF88)
        ));
        supportedTokens.push(SupportedTokens(
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664, 
            0x130966628846BFd36ff31a822705796e8cb8C18D,
            (new address[](3))
                .append(0x55deBF770FC61C8DD9DE4F4A2d90606F3e906B2e)
                    .append(0x5f902030C8AEb8578aC5CC624E243a27b05491c6)
                    .append(0xd0f6e66113A6D6Cca238371948F4Ce2893D62881)
        ));
        supportedTokens.push(SupportedTokens(
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664, 
            0x346A59146b9b4a77100D369a3d18E8007A9F46a6,
            (new address[](1))
                .append(0x5f902030C8AEb8578aC5CC624E243a27b05491c6)
        ));
        supportedTokens.push(SupportedTokens(
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664, 
            0x50b7545627a5162F82A992c33b87aDc75187B218,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
        supportedTokens.push(SupportedTokens(
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664, 
            0x49D5c2BdFfac6CE2BFdB6640F4F80f226bc10bAB,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
        supportedTokens.push(SupportedTokens(
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664, 
            0x9702230A8Ea53601f5cD2dc00fDBc13d4dF4A8c7,
            (new address[](1))
                .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
        supportedTokens.push(SupportedTokens(
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664, 
            0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E,
            (new address[](2))
                .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
                    .append(0x22c62c9E409B97F1f9caA5Ca5433074914d73c3e)
        ));
        supportedTokens.push(SupportedTokens(
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664, 
            0x0f577433Bf59560Ef2a79c124E9Ff99fCa258948,
            (new address[](1))
                .append(0x427d294545FE2E72363568148eEcb02dA7C5e439)
        ));
        supportedTokens.push(SupportedTokens(
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118, 
            0x1C20E891Bab6b1727d14Da358FAe2984Ed9B59EB,
            (new address[](1))
                .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
        ));
        supportedTokens.push(SupportedTokens(
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118, 
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664,
            (new address[](5))
                .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
                    .append(0x77fc17D927eBcEaEA2c4704BaB1AEebB0547ea42)
                    .append(0xd0f6e66113A6D6Cca238371948F4Ce2893D62881)
                    .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
                    .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118, 
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70,
            (new address[](4))
                .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
                    .append(0x77fc17D927eBcEaEA2c4704BaB1AEebB0547ea42)
                    .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
                    .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118, 
            0x130966628846BFd36ff31a822705796e8cb8C18D,
            (new address[](2))
                .append(0x34Fc9F887653B0C1257dB721e413177879004973)
                    .append(0xd0f6e66113A6D6Cca238371948F4Ce2893D62881)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118, 
            0x50b7545627a5162F82A992c33b87aDc75187B218,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118, 
            0x49D5c2BdFfac6CE2BFdB6640F4F80f226bc10bAB,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118, 
            0x9702230A8Ea53601f5cD2dc00fDBc13d4dF4A8c7,
            (new address[](1))
                .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118, 
            0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E,
            (new address[](1))
                .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118, 
            0x0f577433Bf59560Ef2a79c124E9Ff99fCa258948,
            (new address[](1))
                .append(0x427d294545FE2E72363568148eEcb02dA7C5e439)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70, 
            0x1C20E891Bab6b1727d14Da358FAe2984Ed9B59EB,
            (new address[](1))
                .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70, 
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664,
            (new address[](6))
                .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
                    .append(0xc362eaFAa85728893a0d1084D3e2Ff7ffDF2fF88)
                    .append(0x55deBF770FC61C8DD9DE4F4A2d90606F3e906B2e)
                    .append(0x77fc17D927eBcEaEA2c4704BaB1AEebB0547ea42)
                    .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
                    .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70, 
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118,
            (new address[](4))
                .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
                    .append(0x77fc17D927eBcEaEA2c4704BaB1AEebB0547ea42)
                    .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
                    .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70, 
            0x130966628846BFd36ff31a822705796e8cb8C18D,
            (new address[](2))
                .append(0x55deBF770FC61C8DD9DE4F4A2d90606F3e906B2e)
                    .append(0x5302AedD1b484fBe70EFd91Ca0C40785f5B4A69d)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70, 
            0xDC42728B0eA910349ed3c6e1c9Dc06b5FB591f98,
            (new address[](1))
                .append(0x5302AedD1b484fBe70EFd91Ca0C40785f5B4A69d)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70, 
            0x4fbf0429599460D327BD5F55625E30E4fC066095,
            (new address[](1))
                .append(0x5302AedD1b484fBe70EFd91Ca0C40785f5B4A69d)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70, 
            0x50b7545627a5162F82A992c33b87aDc75187B218,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70, 
            0x49D5c2BdFfac6CE2BFdB6640F4F80f226bc10bAB,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70, 
            0x9702230A8Ea53601f5cD2dc00fDBc13d4dF4A8c7,
            (new address[](1))
                .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70, 
            0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E,
            (new address[](1))
                .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70, 
            0x0f577433Bf59560Ef2a79c124E9Ff99fCa258948,
            (new address[](1))
                .append(0x427d294545FE2E72363568148eEcb02dA7C5e439)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E, 
            0x130966628846BFd36ff31a822705796e8cb8C18D,
            (new address[](1))
                .append(0xc362eaFAa85728893a0d1084D3e2Ff7ffDF2fF88)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E, 
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664,
            (new address[](3))
                .append(0xc362eaFAa85728893a0d1084D3e2Ff7ffDF2fF88)
                    .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
                    .append(0x22c62c9E409B97F1f9caA5Ca5433074914d73c3e)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E, 
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70,
            (new address[](2))
                .append(0xc362eaFAa85728893a0d1084D3e2Ff7ffDF2fF88)
                    .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E, 
            0x9702230A8Ea53601f5cD2dc00fDBc13d4dF4A8c7,
            (new address[](1))
                .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
            

        supportedTokens.push(SupportedTokens(
            0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E, 
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118,
            (new address[](1))
                .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x130966628846BFd36ff31a822705796e8cb8C18D, 
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664,
            (new address[](4))
                .append(0xc362eaFAa85728893a0d1084D3e2Ff7ffDF2fF88)
                .append(0x55deBF770FC61C8DD9DE4F4A2d90606F3e906B2e)
                .append(0x5f902030C8AEb8578aC5CC624E243a27b05491c6)
                .append(0xd0f6e66113A6D6Cca238371948F4Ce2893D62881)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x130966628846BFd36ff31a822705796e8cb8C18D, 
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70,
            (new address[](2))
                .append(0x55deBF770FC61C8DD9DE4F4A2d90606F3e906B2e)
                    .append(0x5302AedD1b484fBe70EFd91Ca0C40785f5B4A69d)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x130966628846BFd36ff31a822705796e8cb8C18D, 
            0x346A59146b9b4a77100D369a3d18E8007A9F46a6,
            (new address[](1))
                .append(0x5f902030C8AEb8578aC5CC624E243a27b05491c6)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x130966628846BFd36ff31a822705796e8cb8C18D, 
            0xDC42728B0eA910349ed3c6e1c9Dc06b5FB591f98,
            (new address[](1))
                .append(0x5302AedD1b484fBe70EFd91Ca0C40785f5B4A69d)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x130966628846BFd36ff31a822705796e8cb8C18D, 
            0x4fbf0429599460D327BD5F55625E30E4fC066095,
            (new address[](1))
                .append(0x5302AedD1b484fBe70EFd91Ca0C40785f5B4A69d)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x130966628846BFd36ff31a822705796e8cb8C18D, 
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118,
            (new address[](2))
                .append(0x34Fc9F887653B0C1257dB721e413177879004973)
                .append(0xd0f6e66113A6D6Cca238371948F4Ce2893D62881)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x346A59146b9b4a77100D369a3d18E8007A9F46a6, 
            0x130966628846BFd36ff31a822705796e8cb8C18D,
            (new address[](1))
                .append(0x5f902030C8AEb8578aC5CC624E243a27b05491c6)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x346A59146b9b4a77100D369a3d18E8007A9F46a6, 
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664,
            (new address[](1))
                .append(0x5f902030C8AEb8578aC5CC624E243a27b05491c6)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x4fbf0429599460D327BD5F55625E30E4fC066095, 
            0x130966628846BFd36ff31a822705796e8cb8C18D,
            (new address[](1))
                .append(0x5302AedD1b484fBe70EFd91Ca0C40785f5B4A69d)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x4fbf0429599460D327BD5F55625E30E4fC066095, 
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70,
            (new address[](1))
                .append(0x5302AedD1b484fBe70EFd91Ca0C40785f5B4A69d)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x4fbf0429599460D327BD5F55625E30E4fC066095, 
            0xDC42728B0eA910349ed3c6e1c9Dc06b5FB591f98,
            (new address[](1))
                .append(0x5302AedD1b484fBe70EFd91Ca0C40785f5B4A69d)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x50b7545627a5162F82A992c33b87aDc75187B218, 
            0x49D5c2BdFfac6CE2BFdB6640F4F80f226bc10bAB,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x50b7545627a5162F82A992c33b87aDc75187B218, 
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x50b7545627a5162F82A992c33b87aDc75187B218, 
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x50b7545627a5162F82A992c33b87aDc75187B218, 
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
            

        supportedTokens.push(SupportedTokens(
            0x49D5c2BdFfac6CE2BFdB6640F4F80f226bc10bAB, 
            0x50b7545627a5162F82A992c33b87aDc75187B218,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
        supportedTokens.push(SupportedTokens(
            0x49D5c2BdFfac6CE2BFdB6640F4F80f226bc10bAB, 
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
        supportedTokens.push(SupportedTokens(
            0x49D5c2BdFfac6CE2BFdB6640F4F80f226bc10bAB, 
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
        supportedTokens.push(SupportedTokens(
            0x49D5c2BdFfac6CE2BFdB6640F4F80f226bc10bAB, 
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118,
            (new address[](1))
                .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
        ));
        supportedTokens.push(SupportedTokens(
            0x9702230A8Ea53601f5cD2dc00fDBc13d4dF4A8c7, 
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118,
            (new address[](1))
                .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
        supportedTokens.push(SupportedTokens(
            0x9702230A8Ea53601f5cD2dc00fDBc13d4dF4A8c7, 
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664,
            (new address[](1))
                .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
        supportedTokens.push(SupportedTokens(
            0x9702230A8Ea53601f5cD2dc00fDBc13d4dF4A8c7, 
            0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E,
            (new address[](1))
                .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
        supportedTokens.push(SupportedTokens(
            0x9702230A8Ea53601f5cD2dc00fDBc13d4dF4A8c7, 
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70,
            (new address[](1))
                .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405)
        ));
        supportedTokens.push(SupportedTokens(
            0x57319d41F71E81F3c65F2a47CA4e001EbAFd4F33, 
            0x6e84a6216eA6dACC71eE8E6b0a5B7322EEbC0fDd,
            (new address[](1))
                .append(0x8cC0470f6D53Cd1bdc7A54B7Dd4Fff0D724E47F4)
        ));
        supportedTokens.push(SupportedTokens(
            0x6e84a6216eA6dACC71eE8E6b0a5B7322EEbC0fDd, 
            0x57319d41F71E81F3c65F2a47CA4e001EbAFd4F33,
            (new address[](1))
                .append(0x8cC0470f6D53Cd1bdc7A54B7Dd4Fff0D724E47F4)
        ));
        supportedTokens.push(SupportedTokens(
            0x0f577433Bf59560Ef2a79c124E9Ff99fCa258948, 
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664,
            (new address[](1))
                .append(0x427d294545FE2E72363568148eEcb02dA7C5e439)
        ));
        supportedTokens.push(SupportedTokens(
            0x0f577433Bf59560Ef2a79c124E9Ff99fCa258948, 
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70,
            (new address[](1))
                .append(0x427d294545FE2E72363568148eEcb02dA7C5e439)
        ));
        supportedTokens.push(SupportedTokens(
            0x0f577433Bf59560Ef2a79c124E9Ff99fCa258948, 
            0xc7198437980c041c805A1EDcbA50c1Ce5db95118,
            (new address[](1))
                .append(0x427d294545FE2E72363568148eEcb02dA7C5e439)
        ));
        supportedTokens.push(SupportedTokens(
            0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7, 
            0x2b2C81e08f1Af8835a78Bb2A90AE924ACE0eA4bE,
            (new address[](1))
                .append(0x2F6ca0a98CF8f7D407E98993fD576f70F0FAA80B)
        ));

        // Log gas consumption used to write the supported tokens
        uint gas0 = gasleft();
        for (uint i; i<supportedTokens.length; i++) {
            spRouter.setSPs(
                supportedTokens[i].tkn0, 
                supportedTokens[i].tkn1, 
                supportedTokens[i].adapters
            );
        }
        uint gasUsed = gas0 - gasleft();
        console.log("Gas used to write the supported tokens: ", gasUsed);

    }

    function testSet() public {
        address tkn0 = 0x130966628846BFd36ff31a822705796e8cb8C18D;
        address tkn1 = 0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664;
        address[] memory adapters = (new address[](4))
            .append(0xc362eaFAa85728893a0d1084D3e2Ff7ffDF2fF88)
            .append(0x55deBF770FC61C8DD9DE4F4A2d90606F3e906B2e)
            .append(0x5f902030C8AEb8578aC5CC624E243a27b05491c6)
            .append(0xd0f6e66113A6D6Cca238371948F4Ce2893D62881);
        // Set SPs
        spRouter.setSPs(tkn0, tkn1, adapters);
        // Check SPs were set
        address[] memory setAdapters = spRouter.getSPs(
            0x130966628846BFd36ff31a822705796e8cb8C18D, 
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664
        );
        for (uint i; i<adapters.length; i++) {
            assertEq(setAdapters[i], adapters[i]);
        }
    }

    function testPush() public {
        // Add SP
        spRouter.pushSP(
            0x59414b3089ce2AF0010e7523Dea7E2b35d776ec7, 
            0xdDAaAD7366B455AfF8E7c82940C43CEB5829B604, 
            (new address[](1)).append(0x10EF2400d1a7f64017e80669B218f30ca9816e22)
        );
        // Check SP was added
        address[] memory adapters = spRouter.getSPs(
            0x59414b3089ce2AF0010e7523Dea7E2b35d776ec7, 
            0xdDAaAD7366B455AfF8E7c82940C43CEB5829B604
        );
        assertEq(adapters[adapters.length-1], 0x10EF2400d1a7f64017e80669B218f30ca9816e22);
    }

    function testRemoveOne() public {
        // First set the SPs
        address tkn0 = 0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664;
        address tkn1 = 0xd586E7F844cEa2F87f50152665BCbc2C279D8d70;
        address[] memory adapters = (new address[](5))
            .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
            .append(0x55deBF770FC61C8DD9DE4F4A2d90606F3e906B2e)
            .append(0x77fc17D927eBcEaEA2c4704BaB1AEebB0547ea42)
            .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
            .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405);
        spRouter.setSPs(tkn0, tkn1, adapters);

        // Remove one SP
        address adapterToRm = 0x77fc17D927eBcEaEA2c4704BaB1AEebB0547ea42;
        uint indexToRm = 2;
        assert(adapters[indexToRm] == adapterToRm);
        spRouter.removeSP(tkn0, tkn1, indexToRm);

        address[] memory adaptersModified = spRouter.getSPs(
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664, 
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70
        );
        // Check the SP is replaced with the last value
        assertEq(adaptersModified[indexToRm], adapters[adapters.length-1]); 
        // Check that length decreased by one
        assertEq(adaptersModified.length, adapters.length-1); 
    }

    function testRemoveMultipleSorted() public {
        // First set the SPs
        address tkn0 = 0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664;
        address tkn1 = 0xd586E7F844cEa2F87f50152665BCbc2C279D8d70;
        address[] memory adapters = (new address[](5))
            .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
            .append(0x55deBF770FC61C8DD9DE4F4A2d90606F3e906B2e)
            .append(0x77fc17D927eBcEaEA2c4704BaB1AEebB0547ea42)
            .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
            .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405);
        spRouter.setSPs(tkn0, tkn1, adapters);
        
        // Remove two SPs
        uint[] memory indicesToRm = (new uint[](2)).append(2).append(0);
        spRouter.removeSPs(tkn0, tkn1, indicesToRm);

        address[] memory adaptersModified = spRouter.getSPs(
            0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664, 
            0xd586E7F844cEa2F87f50152665BCbc2C279D8d70
        );
        // Check the SP is replaced with the last value
        assertEq(adaptersModified[indicesToRm[0]], adapters[adapters.length-1]); 
        assertEq(adaptersModified[indicesToRm[1]], adapters[adapters.length-2]); 
        // Check that length decreased by two
        assertEq(adaptersModified.length, adapters.length-2); 
    }

    function testFailRemoveMultipleUnsorted() public {
        // First set the SPs
        address tkn0 = 0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664;
        address tkn1 = 0xd586E7F844cEa2F87f50152665BCbc2C279D8d70;
        address[] memory adapters = (new address[](5))
            .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
            .append(0x55deBF770FC61C8DD9DE4F4A2d90606F3e906B2e)
            .append(0x77fc17D927eBcEaEA2c4704BaB1AEebB0547ea42)
            .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
            .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405);
        spRouter.setSPs(tkn0, tkn1, adapters);
        
        // Remove two SPs
        uint[] memory indicesToRm = (new uint[](2)).append(1).append(2);
        spRouter.removeSPs(tkn0, tkn1, indicesToRm);
    }

    function testFailRemoveMultipleOutOfBounds() public {
        // First set the SPs
        address tkn0 = 0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664;
        address tkn1 = 0xd586E7F844cEa2F87f50152665BCbc2C279D8d70;
        address[] memory adapters = (new address[](5))
            .append(0xE12424c3A50f50aeD8b7e906703Bb1CE93d7EDC8)
            .append(0x55deBF770FC61C8DD9DE4F4A2d90606F3e906B2e)
            .append(0x77fc17D927eBcEaEA2c4704BaB1AEebB0547ea42)
            .append(0x491dc06178CAF5b962DB53576a8A1456a8476232)
            .append(0xDA7C650AA72166aEB7cc335DA429C9047fc0c405);
        spRouter.setSPs(tkn0, tkn1, adapters);
        
        // Remove two SPs
        uint[] memory indicesToRm = (new uint[](2)).append(21).append(1);
        spRouter.removeSPs(tkn0, tkn1, indicesToRm);
    }

}