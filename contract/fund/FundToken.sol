// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FundToken {
    // 1. 通证名称
    // 2. 通证简称
    // 3. 通证发行数量
    // 4. owner地址
    // 5. balance address => uint256
    string public name;
    string public symbol;
    uint256 public totalSupply;
    address public owner;
    mapping (address => uint256) private balances;
    
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;  // 构造函数中初始化owner
    }

    // mint: 获取通证
    function mint(uint256 amountToMint) public {
        balances[msg.sender] += amountToMint;
        totalSupply += amountToMint;
    }

    // transfer： transfer通证
    function transferToken(address payee, uint256 amount) public {
        // 1. balances[msg.sender] => 表示当前地址拥有多少通证
        require(balances[msg.sender] >= amount, "balance not enough"); // 如果余额不足
        
        balances[msg.sender] -= amount;
        balances[payee] += amount;
    }

    // balanceOf：查看某一个地址的通证数量
    function balanceOf(address _account) public view returns(uint256){
        return balances[_account];
    }
    


}