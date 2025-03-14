// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    1.storage   永久性存储，不用显示的添加声明
    2.memory    暂时性存储，运行时可以修改
    3.calldata  暂时性存储，运行时不能修改
    4.stack
    5.codes
    6.logs
*/


contract TipJar {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "There are no tips to withdraw.");
        _;
    }

    function tip() public payable {
        require(msg.value > 0, "You should send a tip to use this function.");
    }

    function withdraw() public onlyOwner {
        
        uint256 contractBalance = address(this).balance;
        
        require(contractBalance > 0, "There are no tips to withdraw.");

        payable(owner).transfer(contractBalance);
    }

    function getBalance() public onlyOwner view returns (uint256) {
        return address(this).balance;
    }
}