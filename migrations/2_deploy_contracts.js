const Thermostat = artifacts.require("Thermostat");
const Thermostat32 = artifacts.require("Thermostat32");

module.exports = function(deployer) {
    deployer.deploy(Thermostat);
    deployer.deploy(Thermostat32);
};
