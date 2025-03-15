// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// 1. 创建一个收款函数
// 2. 记录投资人并且查看
// 3. 在锁定期内，达到目标值，生产商可以提款
// 4. 在锁定期内，没有达到目标值。投资人可以退款

contract FunMe {
    // 投入明细
    mapping(address => uint256) public investments;
    // 最小投入
    uint256 constant MINIMUM_VALUE = 100 * 10**18; //ETH

    AggregatorV3Interface internal dataFeed;
    // 目标
    uint256 constant TARGET = 1000 * 10 ** 18;
    // 合约拥有者
    address public owner;
    // 部署时间戳
    uint256 deploymentTimestamp;
    // 锁定期时长
    uint256 lockTime;

    constructor(uint256 _lockTime) {
        dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        owner = msg.sender;
        deploymentTimestamp = block.timestamp;
        lockTime = _lockTime;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "This function can only be called by the current owner.");
        _;
    }

    modifier windowClosed() {
        require((deploymentTimestamp + lockTime) < block.timestamp, "Window is not closed.");
        _;
    }

    function fund() external payable {
        // 1. 创建一个收款函数
        // 记录投资人
        require(
            convertEthToUsd(msg.value) >= MINIMUM_VALUE,
            "Value is too low!"
        );
        require((deploymentTimestamp + lockTime) > block.timestamp, "Window is closed.");
        uint256 myAmount = investments[msg.sender];
        myAmount += msg.value;
        investments[msg.sender] = myAmount;
    }

    /**
     * Returns the latest answer.
     */
    function getChainlinkDataFeedLatestAnswer() public view returns (int256) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    function convertEthToUsd(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        return (ethAmount * ethPrice) / (10**8);
    }

    function getFund () external onlyOwner windowClosed {
        require(convertEthToUsd(address(this).balance) >= TARGET, "Target is not reached.");

        
        // transfer  纯转账 
        // transfer: transfer ETH and revert if tx failed.
        // addr.transfer(value)
        // payable(msg.sender).transfer(address(this).balance);

        // send      纯转账
        // send: transfer ETH and return false if failed.
        // bool successful = addr.send(value)
        // bool successful = payable(msg.sender).send(address(this).balance);
        // require(successful, "tx failed");

        // call      转账过程中调用方法，也可以纯转账
        // call: transfer ETH with data return value of function and bool
        // (bool, result) = addr.call{value: value}("funcation");
        bool successful;
        (successful, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(successful, "Transfer tx failed.");
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function refund() external windowClosed {
        require((convertEthToUsd(address(this).balance) < TARGET), "Target is reached.");
        require(investments[msg.sender] != 0, "There is no funds for you.");

        bool successful;
        (successful, ) = payable(msg.sender).call{value: investments[msg.sender]}("");
        require(successful, "Transfer tx failed.");
        investments[msg.sender] = 0;
    }
}
