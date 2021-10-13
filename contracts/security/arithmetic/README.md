# Arithmetic Overflow and Underflow

Solidity version before 0.8 allows to hapen overflow and underflow of arithmetic calculations without any errors.
This failure could open vulnerabilities to hack calculations and manipulate the contract expectations in some cases.

This section will use a TimeLock contract to explain this vulnerability and go throught a good practice to show how to prevent it.

## How an overfow could happen in Solidity?
Basically in Solidity uint is equals to uint256, so there is an intervall that a uint variable allows to store a number like. <br>
```
From                To
|-------------------|
0 ----------------- 2**256-1
```

Now suppose we want to store a number **+2 greater than 2 ** 256 - 1** it end up with 0 + 2 that is 1. <br>

```
From                To
|----(+2)-------------|
0 ----1-------------- 2**256-1
```
And if we try +3 will result in 2 and so on.


## How an underfow could happen in Solidity?

In case of underflow we just change the start point for calculation. I mean for overflow we calculate adding from 0 +x, for underflow calculations we get the max value of uint that is 2**256-1, and we start subtracting in the oposite direction. 
Let suppose we want to store a number -1, it will end up with the maximum number(2 ** 256-1), and -2 same as maximum number (2 ** 256-1)

```
From                                To
|----(-2)-----------------------(-1)|
0 ----2**256-2-------------------2**256-1
```

## How to prevent it ?

From solidity 0.8 and beyond, any arithmetic overflow/underflow will automatically throw a revert to prevent any mistake. But for versions before the usage of OpenZeppelin SafeMath library, it takes care of this problem providing the appropriate behavior. <br>
Here the comment from SafeMath confirming that is genarally not needed from  Solidity 0.8 or later:
```
/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
 ```
 This is the link to [SafeMath](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/math/SafeMath.sol) compatible with solidity >= to 0.5, but I strict recommend to check the [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts) repository, to choose the correctly one that fits to your solidity currently version in the project.

## By example

Take a look at **Timelock.sol** contract to see how this vunerabillity works, and **TimelockV2.sol** to learn how to prevent using SafeMath library from OpenZeppelin.