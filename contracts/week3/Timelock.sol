// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/governance/TimelockController.sol";

contract Timelock is TimelockController {
   // minDelay is how long you have to wait before executing
   // proposers is the list of addresses that can propose votes
   // admin is the timelock administrator address (should be revoked after setup)
   constructor(
       uint256 minDelay,
       address[] memory proposers,
       address[] memory executors,
       address admin
   ) TimelockController(minDelay, proposers, executors, admin) {}
}
