# Re-Entrancy

Suposse we have an smart contract A with a certain amount of ether. Now let's say that contract B has some ether ballance in this contract A, and want to withdraws it.
The problems came up when contract B is **allowed to call A before A finishes it execution.

The contract **Attack.sol** will exemplify a possible attack to contract **Etherstore.sol** when preventive techniques are not applied.

# How to prevent a reentrancy ?

1 - Updates the balance then send the ether, see EtherstoreV2 withdraw() function to see the modifications
2 - Create a modifier with locked state variable, see ETherstoreV3 noReentrant modifier to see the modifications

**Obs: The contracts of this section were inpired by solidity-by-example.org**