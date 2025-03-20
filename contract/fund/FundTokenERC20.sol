//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./FundMe.sol";

// 1. 让FundMe的参与者，基于 mapping 来领取相应数量的通证
// 2. 让FundMe的参与者自由transfer通证
// 3. 在使用完成以后，需要burn通证

contract FundTokenERC20 is ERC20 {
    FundMe fundMe;

    constructor(address fundMeAddr) ERC20("FundTokenERC20", "FT"){
        // 初始化时，把参与者地址赋给fundme
        fundMe = FundMe(fundMeAddr);
    }

    function mint(uint256 amountToMint) public {
        require(fundMe.getFundSuccess(), "The FundMe is not completed yet.");
        require(fundMe.investments(msg.sender) >= amountToMint, "You cannot mint that many tokens.");
        _mint(msg.sender, amountToMint);
        fundMe.updateInvestments(msg.sender, fundMe.investments(msg.sender) - amountToMint);
    }

    function claim(uint256 amountToClaim) public {
        // complete claim
        require(balanceOf(msg.sender) >= amountToClaim, "You don't have enough tokens to claim.");
        // TODO
        // something
        // burn amountToClaim Tokens
        _burn(msg.sender, amountToClaim);
    }
}