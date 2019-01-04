pragma solidity ^0.4.24;

import "./Token.sol";

contract Patronage {

  mapping(address => bool) acceptedTokens;
  address public benefactor;

  struct Subscription {
    address subscriberAddress;
    address tokenAddress;
    uint monthlyAmount;
  }

  Subscription[] public subscriptions;

  constructor(address[] _acceptedTokenAddresses) public {
    benefactor = msg.sender;
    for(uint i = 0; i < _acceptedTokenAddresses.length; i++) {
      acceptedTokens[_acceptedTokenAddresses[i]] = true;
    }
  }

  function donate(address tokenAddress, uint amount) public {
    if (tokenAccepted(tokenAddress)) {
      Token token = Token(tokenAddress);
      require(token.transferFrom(msg.sender, benefactor, amount));
    }
  }

  function createMonthlySubscription(address tokenAddress, uint monthlyAmount) public {
    if (tokenAccepted(tokenAddress)) {
      subscriptions.push(Subscription({
        subscriberAddress: msg.sender,
        tokenAddress: tokenAddress,
        monthlyAmount: monthlyAmount
      }));
    }
  }

  function subscriptionAmountFor(address subscriberAddress, address tokenAddress) public returns (uint) {
    uint totalAmount = 0;
    for(uint i = 0; i < subscriptions.length; i++) {
      Subscription subscription = subscriptions[i];
      if (subscription.subscriberAddress == subscriberAddress && subscription.tokenAddress == tokenAddress) {
        totalAmount = totalAmount + subscription.monthlyAmount;
      }
    }
    return totalAmount;
  }

  function tokenAccepted(address _tokenAddress) public view returns (bool) {
    return acceptedTokens[_tokenAddress] == true;
  }

  function elapsedThirtyDayPeriods(uint startTime) public view returns (uint) {
    return (now - startTime) / 30 days;
  }
}
