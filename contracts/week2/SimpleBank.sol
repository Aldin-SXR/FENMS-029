// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SimpleBank {
    mapping(address => uint256) balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance.");
        
        (bool sent,) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether.");

        balances[msg.sender] -= amount;
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
