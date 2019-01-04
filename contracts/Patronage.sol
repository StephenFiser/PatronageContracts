pragma solidity ^0.4.24;

import "./Token.sol";

contract Patronage {

  mapping(address => bool) acceptedTokens;
  address public benefactor;

  constructor(address[] _acceptedTokenAddresses) public {
    benefactor = msg.sender;
    for(uint i = 0; i < _acceptedTokenAddresses.length; i++) {
      acceptedTokens[_acceptedTokenAddresses[i]] = true;
    }
  }

  function tokenAccepted(address _tokenAddress) public view returns (bool) {
    return acceptedTokens[_tokenAddress] == true;
  }

  function donate(address tokenAddress, uint amount) public {
    if (tokenAccepted(tokenAddress)) {
      Token token = Token(tokenAddress);
      require(token.transferFrom(msg.sender, benefactor, amount));
    }
  }

}
