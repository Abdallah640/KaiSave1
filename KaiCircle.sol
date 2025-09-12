// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title KaiCircle
 * @dev A simplified rotating savings group (ROSCA). Each member deposits fixed USDT, 
 * and one member per round receives the pooled funds. (For demo purposes only.)
 */
interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract KaiCircle {
    IERC20 public usdt;
    address[] public members;
    mapping(address => bool) public joined;
    uint256 public contribution;
    uint256 public round;
    uint256 public currentIndex;

    constructor(address _usdt, uint256 _contribution) {
        usdt = IERC20(_usdt);
        contribution = _contribution;
        round = 0;
        currentIndex = 0;
    }

    function join() external {
        require(!joined[msg.sender], "Already joined");
        members.push(msg.sender);
        joined[msg.sender] = true;
    }

    function contribute() external {
        require(joined[msg.sender], "Not a member");
        require(usdt.transferFrom(msg.sender, address(this), contribution), "Contribution failed");
    }

    function payout() external {
        require(members.length > 0, "No members");
        address recipient = members[currentIndex];
        uint256 total = contribution * members.length;
        require(usdt.transfer(recipient, total), "Payout failed");
        currentIndex = (currentIndex + 1) % members.length;
        round++;
    }

    function getMembers() external view returns (address[] memory) {
        return members;
    }
}
