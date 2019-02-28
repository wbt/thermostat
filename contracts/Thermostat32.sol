pragma solidity >=0.4.25 <0.6.0;
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract Thermostat32 is Ownable {
    struct ThermSetting {
        //Temperatures in millidegrees Celsius
        uint32 coolMin;
        uint32 coolMax;
        uint32 heatMin;
        uint32 heatMax;
    }

    //map key = seconds elapsed in year when ThermSetting becomes applicable
    mapping (uint32 => ThermSetting) timespans;

    event coolMinUpdated(uint32 indexed startTime, uint32 oldVal, uint32 newVal);
    event coolMaxUpdated(uint32 indexed startTime, uint32 oldVal, uint32 newVal);
    event heatMinUpdated(uint32 indexed startTime, uint32 oldVal, uint32 newVal);
    event heatMaxUpdated(uint32 indexed startTime, uint32 oldVal, uint32 newVal);

    //At this point in the demo development, assume the receiving code handles
    //zeroes more robustly than actually intepreting a zero value.
    function coolMin(uint32 startSec) public view returns (uint32) {
        return timespans[startSec].coolMin;
    }

    function coolMax(uint32 startSec) public view returns (uint32) {
        return timespans[startSec].coolMax;
    }

    function heatMin(uint32 startSec) public view returns (uint32) {
        return timespans[startSec].heatMin;
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
        emit heatMinUpdated(startSec, timespans[startSec].heatMin, newVal);
        timespans[startSec].heatMin = newVal;
    }

    function setHeatMax(uint32 startSec, uint32 newVal) public onlyOwner {
        emit heatMaxUpdated(startSec, timespans[startSec].heatMax, newVal);
        timespans[startSec].heatMax = newVal;
    }

    function turnUpHeat(uint32 startSec, uint32 delta) public onlyOwner {
        //Note non-use of SafeMath.
        emit heatMinUpdated(startSec, timespans[startSec].heatMin,
            timespans[startSec].heatMin += delta);
        emit heatMaxUpdated(startSec, timespans[startSec].heatMax,
            timespans[startSec].heatMax += delta);
    }

}
