// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title A contract to store and withdraw ether
 * @dev This contract is vulnerable to re-entrancy attack
 * see explanation from solidity-by-example.org bellow:
 * 1. Deploy EtherStore
 * 2. Deposit 1 Ether each from Account 1 (Alice) and Account 2 (Bob) into EtherStore
 * 3. Deploy Attack with address of EtherStore
 * 4. Call Attack.attack sending 1 ether (using Account 3 (Eve)).
 *    You will get 3 Ethers back (2 Ether stolen from Alice and Bob,
 *    plus 1 Ether sent from this contract).
 * 
 * What happened?
 * Attack was able to call EtherStore.withdraw multiple times before
 * EtherStore.withdraw finished executing.
 * 
 * Here is how the functions were called
 * - Attack.attack
 * - EtherStore.deposit
 * - EtherStore.withdraw
 * - Attack fallback (receives 1 Ether)
 * - EtherStore.withdraw
 * - Attack.fallback (receives 1 Ether)
 * - EtherStore.withdraw
 * - Attack fallback (receives 1 Ether) 
 */
contract Etherstore {
    
    mapping(address => uint256) public balances;
    bool internal locked;

    /**
     * @notice It will prevent re-entrancy attacks because,
     * the locked variable will be update to false only when function call has been completed.
     * More requests from same sender during the execution will cause a revert "No re-entrancy".
     */
    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    /**
     * @notice Deposits an amount of ether to Etherstore.
     */
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    /**
     * @notice Withdraws sender balance from Etherstore. 
     * @dev The modifier noReentrant will prevent re-entrancy attack    
     */
    function withdraw() public noReentrant {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "Sender does not have balance");

        (bool sent, ) = msg.sender.call{value: balance}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;
    }

    /**
     * @notice Helper funcion to return the Etherstore current balance.
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}