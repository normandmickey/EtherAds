var PlanetsERC721 = artifacts.require("./PlanetsERC721.sol");

module.exports = function(deployer) {
  deployer.deploy(PlanetsERC721);
};
