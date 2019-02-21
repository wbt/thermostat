# Blockchain-Controlled Thermostat
Let’s mix some trends that are hot topics today: the Internet of Things (IoT), “Smart” homes, energy efficiency, and blockchain.  

In this project, we’re going to build a programmable thermostat controller, which can give you a big “bang for your buck” in terms of energy efficiency gains.  

Today, the most advanced [manual-programming  thermostats](https://www.amazon.com/Honeywell-RTH221B1021-E1-Programmable-Thermostat/dp/B0088A5X5G) generally let you set a weekly schedule with up to four periods per day, each with a time range and temperature setting, and one overall “swing” setting which indicates how much above or below the set point the thermostat should allow.  Some of these allow two programs to be stored, one which runs when the physical switch on the edge of the thermostat is set to “heat,” and another which runs when the switch is set to “cool,” for climate zones that require heating and cooling at different times of the year.  More advanced thermostats, like the “[Nest](https://nest.com/thermostats/nest-learning-thermostat/overview/#meet-the-nest-learning-thermostat),” try to learn your patterns or preference habits, which can require active teaching and doesn’t fare as well when you break or don’t have reliable patterns, due to travel, erratic work schedules, etc., even if you know about these changes in advance.

Existing solutions don’t allow you to plan ahead for special occasions like holidays, when you may be traveling or at home on schedules that might be unusual for a particular time and day of the week.  You might know your holiday plans far in advance, but not get them programmed in during a last-minute preparation rush, or reset promptly afterward.

In this project, we’ll allow a yearly program instead of a weekly program.  We’ll allow the user to set the schedule dynamically, down to the second.  We’ll also allow someone to set their thermostat temperature ranges to the thousandth of a degree, making it easier to specify a swing of 2/3 of a degree (for example) if someone wants to.  The swing will also be programmable per time period.

We’ll store the program on a blockchain, to support traceability of changes to the programming.  Such security can offer some value.  For example, Nest devices get hacked and [attackers can produce unwanted results](https://www.cnet.com/google-amp/news/hacker-uses-nest-cam-to-convince-family-us-is-under-north-korean-missile-attack/); having stronger security and a record of when something was changed can help avoid issues or at least support a target’s investigation of the timeline.  Having a secure audit log could also help mitigate landlord/tenant disputes involving allegations of unauthorized or harassing changes to thermostat settings.

## Blockchain software
This repo contains a demo of the companion blockchain software, specifically starter smart contracts and example migrations for deploying them.  This is meant to be used with [Truffle](https://truffleframework.com/) (to install, run `npm i truffle -g`).

The “timespans” maps a starting time-point to a set of four numbers.  The key (starting time-point) represents the second during the year that the time period starts.  For now, we’ll ignore the existence of leap years and daylight savings time, though there are workarounds for these, such as offsets and helpful interface elements.  Assume our hardware has a clock that starts at 0 at the beginning of each year, and starts counting seconds from there.  When it reaches a second that serves as the key for a mapped struct, values from that struct are loaded in as the active settings.  

If the thermostat’s external switch is in “cool” mode, it’ll turn on a cooling air conditioner if the temperature exceeds coolMax and turn it off if the temperature is less than coolMin.  

If the thermostat’s external switch is in “heat” mode, it’ll fire up a furnace or other heater if the temperature is less than heatMin and turn it off when the temperature exceeds heatMax.  

For smoothing, the thermostat will require multiple sequential reads above or below the threshold temperature.  

The temperatures are specified in millidegrees Celsius.  

OpenZeppelin's "Ownable" interface is used as a starting point to help control security.  In later exercises, we will support multiparty collaborative controls.

## To run
- Clone this repo. Install npm and truffle.  
- Install and start [Ganache](https://truffleframework.com/ganache) or another Ethereum client of your choice.  
[This was tested with Ganache 2.0.0-beta2 in Quickstart settings, truffle v5.0.4, Solidity v0.5.0, Node v9.3.0, npm 6.8.0, and Windows 10 Pro.]
- In a shell, navigate to the directory where this repo was cloned.  
- Run `truffle migrate --reset`.   

The output will tell you where the contract with sample data is deployed, after "contract address" in migration 2.

The current version of the repo will deploy two versions of the contract, one using 32-bit unsigned integers adequate for the task, and another using 256-bit unsigned integers, demonstrating the savings from efficient packing.  

## Future Work
In future exercises, we will cover Raspberry Pi and Arduino solutions to build a thermostat standard interface to read the values and set controls appropriately, by sending the right signals on standard thermostat wires.  
We'll cover considerations around making that interface software verifiable and tamper-resistant.  
We will build a user interface client to read and set values and logs.  
We will also discuss and build automated tests for the smart contracts and other attributes of the distributed application.  
We may also discuss [various](https://digiconomist.net/ethereum-energy-consumption) [perspectives](https://coincenter.org/entry/five-myths-about-bitcoin-s-energy-use) on using a proof of work mechanism to secure nominal local thermostat settings while messing a tiny bit with an effective global thermostat.
