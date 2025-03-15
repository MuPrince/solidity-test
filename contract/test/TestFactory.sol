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

    TipJar tj;

    mapping (string => TipJar) tjs;

    function createContranct(string memory _name) public {
        tj = new TipJar();
        tjs[_name] = tj;
    }

    function getTipJar(string memory _name) public view returns (TipJar){
        TipJar namedTj =  tjs[_name]; // 返回合约
        return namedTj;  
    }
    
    function deleteContranct(string memory _name) public {
        delete tjs[_name];
    }

    function callTipJarTip(string memory _name) public payable {
        tjs[_name].tip();
    }

    function callTipJarWithdraw(string memory _name) public  {
        tjs[_name].withdraw();
    }

    function callGetBalance(string memory _name) public view returns (uint256) {
        return tjs[_name].getBalance();
    }
}