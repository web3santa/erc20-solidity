// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {OurToken} from "../src/OurToken.sol";
import {Script} from "forge-std/Script.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        vm.prank(bob);
        uint256 bobBalance = ourToken.balanceOf(bob);
        assertEq(bobBalance, STARTING_BALANCE);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;
        // allice approve bob to spend token on her behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);
        vm.prank(alice);

        uint256 transferAmount = 600;
        uint256 transferAmount2 = 200;

        ourToken.transferFrom(bob, alice, transferAmount);

        vm.prank(bob);

        ourToken.transfer(alice, transferAmount2);

        console.log(ourToken.balanceOf(alice));

        assertEq(transferAmount2 + transferAmount, ourToken.balanceOf(alice));
    }

    function testBalanceAfterTransfer() public {
        vm.prank(bob);
        uint256 transferAmount = 150;

        ourToken.transfer(alice, transferAmount);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testMint() public {
        vm.prank(msg.sender);

        uint256 mintAmount = 200 ether;

        ourToken.mint(alice, mintAmount);

        console.log(ourToken.balanceOf(alice));

        assertEq(mintAmount, ourToken.balanceOf(alice));
    }

    function testBurn() public {
        vm.prank(msg.sender);

        uint256 mintAmount = 200 ether;
        uint256 mintAmount2 = 1500 ether;

        ourToken.mint(alice, mintAmount);
        ourToken.mint(bob, mintAmount2);

        console.log(ourToken.balanceOf(alice));
        console.log(ourToken.balanceOf(bob));

        uint256 burnAmount = 150 ether;

        ourToken.burn(alice, burnAmount);
        ourToken.burn(bob, mintAmount2);
        console.log(ourToken.balanceOf(alice));
        console.log(ourToken.balanceOf(bob));

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
        assertEq(ourToken.balanceOf(alice), mintAmount - burnAmount);
    }
}
