// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract TheGame {
    address public winner;
    bool public hasEnded;
    uint public reward;
    address private owner;

    uint32 lockPeriodDuration;
    uint public lockPeriodEndTime;

    string private solution;

    constructor(uint32 _lockPeriodDuration, string memory _solution) {
        lockPeriodDuration = _lockPeriodDuration;
        solution = _solution;
        owner = msg.sender;
    }

    modifier onlyDuringLockPeriod() {
        require(block.timestamp < lockPeriodEndTime, "The lock period has ended.");
        _;
    }

    modifier onlyAfterLockPeriod() {
        require(block.timestamp >= lockPeriodEndTime, "The lock period has not ended yet.");
        _;
    }

    function guess(string memory _guess) external payable onlyDuringLockPeriod {
        require(msg.value == 1 ether, "You have to participate with 1 ether.");
        require(!hasEnded, "The game has ended.");

        reward += msg.value;

        if (keccak256(abi.encodePacked(_guess)) == keccak256(abi.encodePacked(solution))) {
            hasEnded = true;
            winner = msg.sender;

            (bool success, ) = msg.sender.call{value: reward}("");
            require(success, "Failed to send reward.");
        }
    }

    function startGame() external {
        require(lockPeriodEndTime == 0, "The game has already started.");
        lockPeriodEndTime = block.timestamp + lockPeriodDuration;
    }

    function getWinner() external view returns (address) {
        return winner;
    }

    function getLockPeriodEndTime() external view returns (uint) {
        return lockPeriodEndTime;
    }
}