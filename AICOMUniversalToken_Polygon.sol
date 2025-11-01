// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AICOMUniversalTokenPolygon {
    string public name = "AICOM Universal Coin";
    string public symbol = "AICOM";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1_000_000_000 ether;
    mapping(address => uint256) public balanceOf;
    event Transfer(address indexed from, address indexed to, uint256 value);
    constructor(){ balanceOf[msg.sender] = totalSupply; }
    function transfer(address to, uint256 value) external returns (bool) {
        require(balanceOf[msg.sender] >= value, "insufficient");
        unchecked { balanceOf[msg.sender] -= value; balanceOf[to] += value; }
        emit Transfer(msg.sender, to, value);
        return true;
    }
}
