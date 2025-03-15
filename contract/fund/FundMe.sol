// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


// 1. 创建一个收款函数
// 2. 记录投资人并且查看
// 3. 在锁定期内，达到目标值，生产商可以提款
// 4. 在锁定期内，没有达到目标值。投资人可以退款

contract FunMe {

    mapping (address => uint256) public investments;

    uint256 MINIMUM_VALUE = 1 * 10 ** 18; //ETH

    AggregatorV3Interface internal dataFeed;

    constructor() {
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function fund() external payable {
        // 1. 创建一个收款函数
        // 记录投资人
        if(msg.value > 0){
            require(msg.value >= MINIMUM_VALUE, "Value is too low!");
            uint256 myAmount = investments[msg.sender];
            myAmount += msg.value;
            investments[msg.sender] = myAmount;
        }
    }

    /**
     * Returns the latest answer.
     */
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
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

}
