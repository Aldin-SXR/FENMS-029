// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract SimpleBankUUPSV2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    mapping(address => uint256) balances;

     function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance.");
        
        balances[msg.sender] -= amount;

        (bool sent,) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether.");
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function version() external pure returns (uint) {
        return 2;
    }
}
