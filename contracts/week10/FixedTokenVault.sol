// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
}

contract FixedTokenVault {
    address public owner;
    mapping(address => mapping(address => uint256)) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    event Deposit(address indexed token, address indexed sender, uint256 amount);
    event Withdrawal(address indexed token, address indexed recipient, uint256 amount);

    bool private locked;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier noReentrant() {
        locked = true;
        _;
        locked = false;
    }

    function deposit(address _token, uint256 _amount) external noReentrant {
        require(_token != address(0), "Invalid token address");
        require(_amount > 0, "Deposit amount must be greater than 0");

        IERC20 token = IERC20(_token);
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= _amount, "Insufficient allowance");

        balances[_token][msg.sender] += _amount;

        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        emit Deposit(_token, msg.sender, _amount);
    }

    function withdraw(address _token, uint256 _amount) external noReentrant {
        require(_token != address(0), "Invalid token address");
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(balances[_token][msg.sender] >= _amount, "Insufficient balance");

        balances[_token][msg.sender] -= _amount;

        IERC20 token = IERC20(_token);
        require(token.transfer(msg.sender, _amount), "Transfer failed");

        emit Withdrawal(_token, msg.sender, _amount);
    }

    function withdrawAll(address _token) external noReentrant {
        uint256 balance = balances[_token][msg.sender];
        require(balance > 0, "No balance to withdraw");

        balances[_token][msg.sender] = 0;

        IERC20 token = IERC20(_token);
        require(token.transfer(owner, balance), "Transfer failed");

        emit Withdrawal(_token, owner, balance);
    }

    function getBalance(address _token) external view returns (uint256) {
        return  balances[_token][msg.sender];
    }
}