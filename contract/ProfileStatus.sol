// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

/*
    1.storage   永久性存储，不用显示的添加声明
    2.memory    暂时性存储，运行时可以修改
    3.calldata  暂时性存储，运行时不能修改
    4.stack
    5.codes
    6.logs


    struct    结构体
    array     数组
    mapping   映射


    tuple     元组
    enum      枚举
    bytes32   字节数组
    bytes     字节数组
    address   地址
    bool      布尔值
    uint      无符号整形
    int256   有符号整形

*/

contract ProfileStatus {
    struct Status {
        string name;
        string message;
    }

    mapping(address => Status) private userStatus;

    function createOrUpdateStatus(string memory _name, string memory _message)
        public
    {
        userStatus[msg.sender].name = _name;
        userStatus[msg.sender].message = _message;
    }

    function getUserStatus()
        public
        view
        returns (string memory, string memory)
    {
        return (userStatus[msg.sender].name, userStatus[msg.sender].message);
    }
}
