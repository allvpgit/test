const { ethers } = require("hardhat");
const { expect } = require("chai");
BigInt.prototype.format = function () {
  return this.toLocaleString("de-DE");
};

describe("BonusFee", function() {
  let bonusFee;
  let deployer, signer1, signer2;

  before(async function (){
    bonusFee = await ethers.deployContract("BonusFee");
    [deployer, signer1, signer2] = await ethers.getSigners();
  })
})