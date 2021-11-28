const MySimpleToken = artifacts.require("MySimpleToken");

module.exports = function (deployer) {
   deployer.deploy(MySimpleToken, "MySimpleToken", "MST", 10000000000000);
};
