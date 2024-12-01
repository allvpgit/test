// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract BonusFee {
    uint256 constant MAX_PERCENT = 100 * 1e8;

    address public owner;
    address public operator;
    uint256 public optimalCapacity;
    uint256 public targetCapacity;
    uint256 public bonusRateA;
    uint256 public bonusRateB;

    error NotOwner(address account);
    error NotOperator(address account);
    error NullParams();

    event OperatorChanged(address prevValue, address newValue);

    constructor() {
        owner = msg.sender;
        optimalCapacity = 10 ether;
        targetCapacity = 20 ether;
        bonusRateA = 2 * 1e8;
        bonusRateB = 1e8;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwner(msg.sender);
        }
        _;
    }

    modifier onlyOperator() {
        if (msg.sender != operator) {
            revert NotOperator(msg.sender);
        }
        _;
    }

    function setOperator(address _operator) external onlyOwner {
        if (_operator == address(0)) {
            revert NullParams();
        }
        emit OperatorChanged(operator, _operator);
        operator = _operator;
    }

    function calculateDepositBonus(
        uint256 amount,
        uint256 capacity
    ) external view returns (uint256 bonus) {
        /// @dev the utilization rate is in the range [0:25] %
        if (amount > 0 && capacity < optimalCapacity) {
            uint256 replenished = amount;
            if (optimalCapacity < capacity + amount)
                replenished = optimalCapacity - capacity;

            capacity += replenished;
            bonus += (replenished * bonusRateA) / MAX_PERCENT;
            amount -= replenished;
        }
        /// @dev the utilization rate is in the range [25: ] %
        if (amount > 0 && capacity <= targetCapacity) {
            uint256 replenished = targetCapacity > capacity + amount
                ? amount
                : targetCapacity - capacity;

            bonus += (replenished * bonusRateB) / MAX_PERCENT;
        }
    }
}
