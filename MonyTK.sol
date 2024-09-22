// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MonyTK is ERC20 {
    constructor() ERC20("MonyTK", "MTK") {
        _mint(msg.sender, 30 * 10 ** decimals());
    }
}