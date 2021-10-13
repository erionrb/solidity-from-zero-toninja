// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <=0.8.9;

/**
 * @notice Contract to represent a time vault with a overflow/underflow vulnerability.
 * @dev Solidity 0.8 and beiond does not apply for same code behavior.
 */
contract TimeLock {
    
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    /**
     * @notice Deposits some amount of ether with 1 week as timelock
     */
    function deposit() external payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    /**
     * @notice Increase the lock time in seconds.
     * @param _secondsToIncrease How many seconds it will increase
     * @dev This function is exposed to overflow/underflow vulnerability
     */
    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] += _secondsToIncrease;
    }

    /**
     * @notice Withdraws the sender total amount of this contract.
     * @dev The require() is not sufficient to prevent the overflow/underflow vunerability
     */
    function withdraw() public {
        require(balances[msg.sender] > 0, "Insufficient funds");
        // Unfortunattly this is not sufficient to be safe
        require(block.timestamp > lockTime[msg.sender], "Lock time not expired");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
