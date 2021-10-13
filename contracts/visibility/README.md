# Visibility and Getters

Solidity knows two kinds of function calls, internal that does not create an EVM call and externals that do. Due to it, four visibility types to functions and state variables exist. We'll take a look at all of them in this section.


### external
External functions can be called by other contracts or via transactions, but when used for internal calls, it is not allowed without the **"this"** keyword.

**correct usage** <br>
`this.myFunction();`

**wrong usage, will not work** <br>
`myFunction();`

**OBS: applicable only to functions**


### public
Enable functions internal call or via messages. For variables will automatically generate a getter corresponding function.

**getter variable auto generated** <br>
`uint256 public number;`

`myContract.number() // Calling the autogenerated getter of number state variable`

### internal
The default visibility of state variables, functions, and variables with this visibility can be accessed only by or derived contracts.

### private
The more restrictive visibility turns the function and variables not accessible outside the contract scope.