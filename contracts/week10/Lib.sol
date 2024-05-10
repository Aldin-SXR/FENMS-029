// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Lib {
    uint256 public someNumber;

    function doSomething(uint256 _num) external {
        someNumber = _num;
    }
}