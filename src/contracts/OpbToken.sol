// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./IERC20.sol"

contract OPB is ERC20 {
    constructor() ERC20("OpenBrowser", "OPB") {
        _mint(msg.sender, 1000 * 10 ** decimals());
    }
}