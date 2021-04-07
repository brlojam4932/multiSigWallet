const Wallet = artifacts.require("Wallet");

module.exports = function (deployer, accounts) {
  address = ["0xdc6bbc41d7ff0accd096969921067c07cd3b0d37", "0xe8b2ef888b7059907fe4eeed19892aac95c7e961", "0x87710DfA8D5210d21A44bCB9947755DA22f3A707"];
  uint = 2;
  const userAddress = accounts[0,1,2];
  deployer.deploy(Wallet, ["0xdc6bbc41d7ff0accd096969921067c07cd3b0d37", "0xe8b2ef888b7059907fe4eeed19892aac95c7e961", "0x87710DfA8D5210d21A44bCB9947755DA22f3A707"], 2);
  
};