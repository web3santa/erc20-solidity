// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ManualToken {
    mapping(address => uint256) private s_balance;

    string private s_name = "Menual Token";

    constructor() {}

    function name() public view returns (string memory) {
        return s_name;
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether; // 100 * 18
    }

    function decimals() public pure returns (uint8) {
        return 18; // 18 decimals
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balance[_owner];
    }

    function transfer(address _to, uint256 _value) public {
        uint256 previousBalance = balanceOf(msg.sender) + balanceOf(_to);
        s_balance[msg.sender] -= _value;
        s_balance[_to] += _value;

        require(
            s_balance[msg.sender] + s_balance[_to] == previousBalance,
            "Not Enough ETH"
        );
    }
}
