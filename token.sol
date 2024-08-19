// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor() ERC20("Okoin", "OKO") { 
        _mint(msg.sender, 10000000 * 10**18);
    }
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
    
}