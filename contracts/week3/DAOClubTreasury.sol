// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract DAOClubTreasury {
    uint private balance;
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Must be the owner.");
        _;
    }

    function deposit() external payable {
        balance += msg.value;
    }

    function withdraw(uint256 _amount, address payable _to) external onlyOwner {
        require(balance >= _amount, "Insufficient balance.");
        
        balance -= _amount;

        (bool sent,) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether.");
    }

    function getBalance() public view returns (uint256) {
        return balance;
    }
}
