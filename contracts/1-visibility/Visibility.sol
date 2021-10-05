// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @notice A simple contract to explain how visibility works in solidity
 */
contract Visibility {

    // public state variable will generate a getter function by default,
    // value() as called outside
    uint256 public value;

    /**
     * @notice Constructors are defined with {constructor} keyword 
     * and executed once as contract deployment
     */
    constructor() {
        initContract();
    }

    /**
     * @notice Defined as public will imply on visibility internal or outside the contract
     * even for another contract call.
     */
    function changeValue(uint256 _newValue) public {
        value = _newValue;
    }

    /**
     * @notice Can be used by other contracts to get the double amount of the current value
     * @dev to be used internally should add {this} keyword: this.getDouble()
     */
    function getDouble() external view returns (uint256) {
        return value * 2;
    }

    /**
     * @notice Visible only to the contract or derived types
     */
    function getTripple() internal view returns (uint256) {
        // Without the keyword 'this' it does not compile, once getDouble is an external function
        return this.getDouble() + value;
    }

    /**
     * @notice This funciton is the more restrictive as possible, it it visible only to this contract.
     */
    function initContract() private {
        value = 1;
    }

}