pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Token is ERC20, Ownable {

    string public name;
    string public symbol;
    uint8 public decimals = 18;

    constructor(string _name, string _symbol) public {
        name = _name;
        symbol = _symbol;
        _mint(msg.sender, 1000000 ether);
    }
    
}
