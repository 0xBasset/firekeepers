// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.7;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {DSInvariantTest} from "./utils/DSInvariantTest.sol";

import {Firekeepers} from "../contracts/Firekeepers.sol";

import {ERC721TokenReceiver} from "../contracts/Firekeepers.sol";


import {Vm} from  "./utils/Interfaces.sol";
contract FirakeepersTest is DSTestPlus, ERC721TokenReceiver  {

    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    Firekeepers fire;

    uint256 startingBlock = 10000;

    function setUp() public {
        fire = new Firekeepers("Firekeepers", "FIREKEEPERS", 75, 50400);

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
        assertEq(fire.indexOf(1), 75);
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
        assertEq(fire.indexOf(1), 75);

        vm.roll(startingBlock + 10);

        vm.prank(address(2));
        fire.mint();

        // After minting
        assertEq(fire.currentId(),  2);
        assertEq(fire.balanceOf(address(2)), 1);
        assertEq(fire.ownerOf(2), address(2));
        assertEq(fire.lastMinted(), startingBlock + 10);
        assertEq(fire.indexOf(2), 65);
    }


    function test_mint_failAfterGameIsOver() public {
        // Mint first one
        fire.mint();

        vm.roll(startingBlock + 76);

        vm.prank(address(2));
        vm.expectRevert("GAME OVER");
        fire.mint();
    }
    
}
