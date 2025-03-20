// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FundToken is ERC20 {
    // 1. 通证名称
    // 2. 通证简称
    // 3. 通证发行数量
    // 4. owner地址
    // 5. balance address => uint256

    // mint: 

    constructor() ERC20("FundToken", "FT") {}
}