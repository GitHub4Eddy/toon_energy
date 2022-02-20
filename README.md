# toon_energy
This Quickapp retrieves energy consumption, energy production and gas usage from the Toon Energymeter

This QuickApp has Child Devices for Consumption (Watt), Production (Watt), Consumption High (kWh), Consumption Low (kWh), Production High (kWh), Production Low (kWh), Production Actual (Watt), Gas Usage (l/h) and Total Gas (m³)

The Energy Usage from the Child devices Consumption High, Consumption Low, Production High and Production Low can be used for the HC3 Energy Panel

The Toon needs to be rooted, see: https://github.com/JackV2020/Root-A-Toon-USB-Stick. 
This is the recommended all in one solution for a one time boot from USB stick, 10 minutes of work and done. 

After rooting you don't need a subscription anymore and you have access to a ToonStore with a growing number of apps. For more technical people there is a possibility to ssh into the Toon if they want with username root and password toon. Rooting is at your own risk, look here for further support and info: 
See also: https://github.com/ToonSoftwareCollective/Root-A-Toon (if you already have a running Linux environment)
See also: https://toonforum.nl/ 
See also: https://www.domoticaforum.eu/

Version 1.3 (20th February 2022)
- Solved issue with "NaN" responses or other bad responses from Toon Energy
- Added child device voor actual solar production

Version 1.2 (27th December 2021)
- Solved code error with toonVersion

Version 1.1 (27th December 2021)
- Added support for Toon version 1
- Added Simulation notice in labels

Version 1.0 (3th October 2021)
- Ready for download

Version 0.2 (30th September 2021)
- Gas from m³/h to l/h
- Splashed a bug

Version 0.1 (29th September 2021)
- Initial version


Variables (mandatory): 
- IPaddress = IP address of your Toon Meter
- Interval = Number in seconds 
- debugLevel = Number (1=some, 2=few, 3=all, 4=simulation) (default = 1)
