const chai = require('chai');
chai.should();

const Patronage = artifacts.require("./Patronage.sol");
const Token = artifacts.require("./Token.sol");
const utils = web3._extend.utils

contract('Patronage', async (accounts) => {

  before(async () => {
    benefactor = accounts[0]
    usdc = await Token.new('United States Dollar Token', 'usdc', { from: accounts[3] });
    euro = await Token.new('Euro', 'euro', { from: accounts[3] });
    patronage = await Patronage.new([usdc.address]);
    await usdc.approve(patronage.address, utils.toWei(1000000), { from: accounts[3] });
    await euro.approve(patronage.address, utils.toWei(1000000), { from: accounts[3] });
  })

  describe('contructor()', () => {
    it('should have a whitelist of token addresses that the benefactor accepts', async () => {
      let tokenAccepted = await patronage.tokenAccepted.call(usdc.address);
      tokenAccepted.should.equal(true);
    });
  });

  describe('donate()', () => {
    it('accepts one time donations and sends them to the benefactor', async () => {
      await patronage.donate(usdc.address, utils.toWei('100'), { from: accounts[3] }); // donate $100
      let benefactorBalance = await usdc.balanceOf.call(benefactor);
      let formattedBalance = benefactorBalance.toNumber();
      formattedBalance.should.equal(Number(utils.toWei(100)))
    });

    it('does not accept tokens that are not whitelisted', async () => {
      let currentBenefactorBalance = await euro.balanceOf.call(benefactor);
      let formattedCurrentBalance = currentBenefactorBalance.toNumber();

      await patronage.donate(euro.address, utils.toWei('100'), { from: accounts[3] });

      let benefactorBalance = await euro.balanceOf.call(benefactor);
      let formattedBalance = benefactorBalance.toNumber();
      formattedBalance.should.equal(formattedCurrentBalance);
    });
  });

  describe('createMonthlySubscription()', () => {
    it('allows users to set up a monthly donation amount', async () => {
      await patronage.createMonthlySubscription(usdc.address, utils.toWei(20), { from: accounts[3] });
      let subscriptionAmount = await patronage.subscriptionAmountFor.call(accounts[3], usdc.address);
      let formattedAmount = subscriptionAmount.toNumber();
      formattedAmount.should.equal(Number(utils.toWei(20)));
    });
  });

  describe('elapsedThirtyDayPeriods()', () => {
    it('calculates the number of thirty day periods between a provided start and the current block time', async () => {
      let elapsedCount = await patronage.elapsedThirtyDayPeriods.call(1530428912)
      let formattedCount = elapsedCount.toNumber()
      formattedCount.should.equal(6);
    });
  });

});
