// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title KaiVault
 * @dev A simple stablecoin savings vault where users can deposit and withdraw USDT.
 * Interest logic is simplified (mockup for demo purposes).
 */
interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract KaiVault {
    IERC20 public usdt;
    mapping(address => uint256) public balances;

    constructor(address _usdt) {
        usdt = IERC20(_usdt);
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Deposit amount must be > 0");
        require(usdt.transferFrom(msg.sender, address(this), amount), "USDT transfer failed");
        balances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        require(usdt.transfer(msg.sender, amount), "USDT transfer failed");
    }

    function balanceOf(address user) external view returns (uint256) {
        return balances[user];
    }
}
