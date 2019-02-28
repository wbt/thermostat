pragma solidity >=0.4.25 <0.6.0;
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract Thermostat is Ownable {
    struct ThermSetting {
        //Temperatures in millidegrees Celsius
        uint coolMin;
        uint coolMax;
        uint heatMin;
        uint heatMax;
    }

    //map key = seconds elapsed in year when ThermSetting becomes applicable
    mapping (uint => ThermSetting) timespans;

    event coolMinUpdated(uint indexed startTime, uint oldVal, uint newVal);
    event coolMaxUpdated(uint indexed startTime, uint oldVal, uint newVal);
    event heatMinUpdated(uint indexed startTime, uint oldVal, uint newVal);
    event heatMaxUpdated(uint indexed startTime, uint oldVal, uint newVal);

    //At this point in the demo development, assume the receiving code handles
    //zeroes more robustly than actually intepreting a zero value.
    function coolMin(uint startSec) public view returns (uint) {
        return timespans[startSec].coolMin;
    }

    function coolMax(uint startSec) public view returns (uint) {
        return timespans[startSec].coolMax;
    }

    function heatMin(uint startSec) public view returns (uint) {
        return timespans[startSec].heatMin;
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
        emit heatMinUpdated(startSec, timespans[startSec].heatMin, newVal);
        timespans[startSec].heatMin = newVal;
    }

    function setHeatMax(uint startSec, uint newVal) public onlyOwner {
        emit heatMaxUpdated(startSec, timespans[startSec].heatMax, newVal);
        timespans[startSec].heatMax = newVal;
    }

    function turnUpHeat(uint startSec, uint delta) public onlyOwner {
        //Note non-use of SafeMath.
        emit heatMinUpdated(startSec, timespans[startSec].heatMin,
            timespans[startSec].heatMin += delta);
        emit heatMaxUpdated(startSec, timespans[startSec].heatMax,
            timespans[startSec].heatMax += delta);
    }

}
