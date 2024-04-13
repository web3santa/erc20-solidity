// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {OurToken} from "../src/OurToken.sol";
import {Script} from "forge-std/Script.sol";

contract DeployOutToken is Script {
    uint256 public constant INITAL_SUPPLY = 1000 ether;

    function run() external {
        vm.startBroadcast();
        new OurToken(INITAL_SUPPLY);
        vm.stopBroadcast();
    }
}
