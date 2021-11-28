const Sale = artifacts.require("Sale");

module.exports = function (deployer) {
   deployer.deploy(Sale, "Hello world!");
};
