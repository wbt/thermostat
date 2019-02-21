pragma solidity >=0.4.25 <0.6.0;
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract Thermostat32 is Ownable {
    struct ThermSetting {
        //Temperatures in millidegrees Celsius
        uint32 coolMin;
        uint32 coolMax;
        uint32 heatLow;
        uint32 heatMax;
    }

    //map key = seconds elapsed in year when ThermSetting becomes applicable
    mapping (uint32 => ThermSetting) timespans;

    event coolMinUpdated(uint32 indexed startTime, uint32 oldVal, uint32 newVal);
    event coolMaxUpdated(uint32 indexed startTime, uint32 oldVal, uint32 newVal);
    event heatLowUpdated(uint32 indexed startTime, uint32 oldVal, uint32 newVal);
    event heatMaxUpdated(uint32 indexed startTime, uint32 oldVal, uint32 newVal);

    //At this point in the demo development, assume the receiving code handles
    //zeroes more robustly than actually intepreting a zero value.
    function coolMin(uint32 startSec) public view returns (uint32) {
        return timespans[startSec].coolMin;
    }

    function coolMax(uint32 startSec) public view returns (uint32) {
        return timespans[startSec].coolMax;
    }

    function heatLow(uint32 startSec) public view returns (uint32) {
        return timespans[startSec].heatLow;
    }

    function heatMax(uint32 startSec) public view returns (uint32) {
        return timespans[startSec].heatMax;
    }

    function setCoolMin(uint32 startSec, uint32 newVal) public onlyOwner {
        emit coolMinUpdated(startSec, timespans[startSec].coolMin, newVal);
        timespans[startSec].coolMin = newVal;
    }

    function setCoolMax(uint32 startSec, uint32 newVal) public onlyOwner {
        emit coolMaxUpdated(startSec, timespans[startSec].coolMax, newVal);
        timespans[startSec].coolMax = newVal;
    }

    function setHeatMin(uint32 startSec, uint32 newVal) public onlyOwner {
        emit heatLowUpdated(startSec, timespans[startSec].heatLow, newVal);
        timespans[startSec].heatLow = newVal;
    }

    function setHeatMax(uint32 startSec, uint32 newVal) public onlyOwner {
        emit heatMaxUpdated(startSec, timespans[startSec].heatMax, newVal);
        timespans[startSec].heatMax = newVal;
    }

}
