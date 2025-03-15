// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;



contract FavoriteNumber {

    mapping(string => uint256) private nameTofavoriteNumber;

    function createOrUpdateFavoriteNumber(string memory name, uint256 number) public {
        nameTofavoriteNumber[name] = number;
    }
    
    function getFavoriteNumberByName(string memory name) public view returns (uint256){
        return nameTofavoriteNumber[name];
    }
}