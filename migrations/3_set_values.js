const Thermostat = artifacts.require("Thermostat");
const Thermostat32 = artifacts.require("Thermostat32");
const MAX_SECONDS_IN_YEAR = 60*60*24*366;
//Some parameters you can change:
const MAX_TIMEPOINTS_IN_TEST = 6; //6, 60, 600, take your pick; lower numbers run faster.
const INTERVAL_BETWEEN_POINTS = 60*60*6; //change temp every 6 hours
const START_TIME = 1; //seconds in year for first setting; last year wraps around prior to this.

//This migration sets some semi-random example values.

module.exports = function(deployer) {
    var thermostat, thermostat32;
    deployer.then(function() {
        return Thermostat.deployed();
    }).then(function(instance) {
        thermostat = instance;
        return Thermostat32.deployed();
    }).then(async function(instance) {
        thermostat32 = instance;
        console.log("Setting thermostat values.");
        var consumption = await programThermostat(thermostat);
        console.log("Consumption in wei for uint version:   "+consumption);
        var consumption32 = await programThermostat(thermostat32);
        console.log("Consumption in wei for uint32 version: "+consumption32);
        var uintPenaltyPct = (((consumption-consumption32)/consumption32)*100).toFixed(1);
        //uintPenaltyPct = 32.5% in initial tests
        console.log("Using uint instead of uint32 resulted in a "+uintPenaltyPct+"% efficiency penalty.");
    }).catch(function(error) {
        console.log("Error processing transactions: "+error);
    });
};

programThermostat = async function (instance) {
    var coolMin, coolMax, heatMin, heatMax, coolSwing, heatSwing;
    var startingBalance = await getBalance();
    var stopTime = Math.min(MAX_SECONDS_IN_YEAR, INTERVAL_BETWEEN_POINTS*MAX_TIMEPOINTS_IN_TEST)
    for (var seconds = START_TIME; seconds <= stopTime; seconds += INTERVAL_BETWEEN_POINTS) {
        //Values are in millidegrees Celsius.
        coolSwing = getRandomInt(250, 2000);
        heatSwing = getRandomInt(250, 2000);
        coolMin = getRandomInt(23000, 27000);
        heatMin = getRandomInt(16000, 21000);
        coolMax = coolMin + coolSwing;
        heatMax = heatMin + heatSwing;
        await setThermostat(instance, seconds, coolMin, coolMax, heatMin, heatMax);
    }
    var endingBalance = await getBalance();
    //Measure assumes no other activity on account during migration.
    var balanceDifference = startingBalance - endingBalance;
    return balanceDifference;
}

//Adapted from https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
getRandomInt = function (min, max) { //min and max are inclusive
    min = Math.ceil(min);
    max = Math.floor(max)+1;
    return Math.floor(Math.random() * (max - min)) + min;
}

getBalance = function () {
    return new Promise(function(resolve, reject) {
        web3.eth.getAccounts(function(error,accounts) {
            if(error) {
                console.log(error);
                reject(error);
            } else {
                resolve(web3.eth.getBalance(accounts[0]));
            }
        });
    });
}

setThermostat = function (instance, seconds, coolMin, coolMax, heatMin, heatMax) {
    var transactionPromises = [];
    transactionPromises.push(instance.setCoolMin(seconds, coolMin));
    transactionPromises.push(instance.setCoolMax(seconds, coolMax));
    transactionPromises.push(instance.setHeatMin(seconds, heatMin));
    transactionPromises.push(instance.setHeatMax(seconds, heatMax));
    return Promise.all(transactionPromises);
};
