// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {TipJar} from "./TipJar.sol"; //  引入本地合约

// import {contract***} from "https://www.github.com/********";   通过url地址引入合约
// import {contract***} from "@companyName/product/contract";     通过包引入合约



/*
    Contract factory for the TipJar smart contract.
    工厂模式测试代码
*/
contract TestFactory{

    address public creator;
    address public currentOwner;

    TipJar tj;


    constructor() {
        creator = msg.sender;
        currentOwner = creator; 
    }


    function createContranct() public {
        

    }

}