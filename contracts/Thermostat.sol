pragma solidity >=0.4.25 <0.6.0;
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract Thermostat is Ownable {
    struct ThermSetting {
        //Temperatures in millidegrees Celsius
        uint coolMin;
        uint coolMax;
        uint heatLow;
        uint heatMax;
    }

    //map key = seconds elapsed in year when ThermSetting becomes applicable
    mapping (uint => ThermSetting) timespans;

    event coolMinUpdated(uint indexed startTime, uint oldVal, uint newVal);
    event coolMaxUpdated(uint indexed startTime, uint oldVal, uint newVal);
    event heatLowUpdated(uint indexed startTime, uint oldVal, uint newVal);
    event heatMaxUpdated(uint indexed startTime, uint oldVal, uint newVal);

    //At this point in the demo development, assume the receiving code handles
    //zeroes more robustly than actually intepreting a zero value.
    function coolMin(uint startSec) public view returns (uint) {
        return timespans[startSec].coolMin;
    }

    function coolMax(uint startSec) public view returns (uint) {
        return timespans[startSec].coolMax;
    }

    function heatLow(uint startSec) public view returns (uint) {
        return timespans[startSec].heatLow;
    }

    function heatMax(uint startSec) public view returns (uint) {
        return timespans[startSec].heatMax;
    }

    function setCoolMin(uint startSec, uint newVal) public onlyOwner {
        emit coolMinUpdated(startSec, timespans[startSec].coolMin, newVal);
        timespans[startSec].coolMin = newVal;
    }

    function setCoolMax(uint startSec, uint newVal) public onlyOwner {
        emit coolMaxUpdated(startSec, timespans[startSec].coolMax, newVal);
        timespans[startSec].coolMax = newVal;
    }

    function setHeatMin(uint startSec, uint newVal) public onlyOwner {
        emit heatLowUpdated(startSec, timespans[startSec].heatLow, newVal);
        timespans[startSec].heatLow = newVal;
    }

    function setHeatMax(uint startSec, uint newVal) public onlyOwner {
        emit heatMaxUpdated(startSec, timespans[startSec].heatMax, newVal);
        timespans[startSec].heatMax = newVal;
    }

}
