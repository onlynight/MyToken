const EIP20Factory = artifacts.require("./EIP20Factory.sol");

module.exports = function(deployer){
    deployer.deploy(EIP20Factory);
}