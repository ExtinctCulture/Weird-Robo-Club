const ExtinctionToken = artifacts.require("ExtinctionToken");

module.exports = function(deployer) {
  deployer.deploy(ExtinctionToken);
};
