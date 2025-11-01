// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * AICOM UNIVERSAL TOKEN (Main Ethereum Contract)
 * Author: R-M-P — AICOM Multichain Initiative
 * Purpose: Universal Coin for AICOM Network
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AICOMUniversalToken is ERC20, Ownable {
    uint8 private constant DECIMALS = 18;
    uint256 private constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(DECIMALS));

    constructor() ERC20("AICOM UNIVERSAL COIN", "AICU") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function decimals() public pure override returns (uint8) {
        return DECIMALS;
    }
}
