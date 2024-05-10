// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ExampleContract {
    address public lib;
    address public owner;
    uint256 public someNumber;

    constructor(address _lib) {
        lib = _lib;
        owner = msg.sender;
    }

    function doSomething(uint256 _num) external {
        lib.delegatecall(abi.encodeWithSignature("doSomething(uint256)", _num));
    }
}