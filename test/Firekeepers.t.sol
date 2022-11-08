// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.7;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {DSInvariantTest} from "./utils/DSInvariantTest.sol";

import {Firekeepers} from "../contracts/Firekeepers.sol";
import {Proxy} from "../contracts/Proxy.sol";

import {ERC721TokenReceiver} from "../contracts/Firekeepers.sol";


import {Vm} from  "./utils/Interfaces.sol";

contract FirakeepersTest is DSTestPlus, ERC721TokenReceiver  {

    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    Firekeepers fire;

    uint256 startingBlock = 10000;

    function setUp() public {
        fire = Firekeepers(address(new Proxy(address(new Firekeepers()))));
        fire.initialize("Firekeepers", "FIREKEEPERS", 75, 21600);

        vm.roll(startingBlock);
    }

    function test_mint_correctly() public {
        // Initial state
        assertEq(fire.currentId(),  0);
        assertEq(fire.balanceOf(address(this)), 0);
        
        fire.mint();

        // After minting
        assertEq(fire.currentId(),  1);
        assertEq(fire.balanceOf(address(this)), 1);
        assertEq(fire.ownerOf(1), address(this));
        assertEq(fire.lastMinted(), startingBlock);
        assertEq(fire.emberOf(1), 75);
    }

    function test_mint_twoUsers_correctly() public {
        // Initial state
        assertEq(fire.currentId(),  0);
        assertEq(fire.balanceOf(address(this)), 0);
        
        fire.mint();

        // After minting
        assertEq(fire.currentId(),  1);
        assertEq(fire.balanceOf(address(this)), 1);
        assertEq(fire.ownerOf(1), address(this));
        assertEq(fire.lastMinted(), startingBlock);
        assertEq(fire.emberOf(1), 75);

        vm.roll(startingBlock + 10);

        vm.prank(address(2));
        fire.mint();

        // After minting
        assertEq(fire.currentId(),  2);
        assertEq(fire.balanceOf(address(2)), 1);
        assertEq(fire.ownerOf(2), address(2));
        assertEq(fire.lastMinted(), startingBlock + 10);
        assertEq(fire.emberOf(2), 65);
    }


    function test_mint_failAfterGameIsOver() public {
        // Mint first one
        fire.mint();

        vm.roll(startingBlock + 76);

        vm.prank(address(2));
        vm.expectRevert("GAME OVER");
        fire.mint();
    }
    
    function test_transfer_afterMaturity() public {
        // Mint first one
        fire.mint();

        vm.expectRevert("NOT MATURED");
        fire.transferFrom(address(this), address(2), 1);

        for (uint256 i = 0; i < 305; i++) {
            vm.roll(block.number + 74);
            fire.mint();
        }

        // first one should be matured
        fire.transferFrom(address(this), address(2), 1);

        // Last one still untransferable
        vm.expectRevert("NOT MATURED");
        fire.transferFrom(address(this), address(2), 300);
    }
}
