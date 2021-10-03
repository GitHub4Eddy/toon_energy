-- QUICKAPP TOON ENERGY

-- This Quickapp retrieves energy consumption, energy production and gas usage from the Toon Energymeter

-- This QuickApp has Child Devices for Consumption (Watt), Production (Watt), Consumption High (kWh), Consumption Low (kWh), Production High (kWh), Production Low (kWh), Gas Usage (l/h) and Total Gas (m³)

-- The Energy Usage from the Child devices Consumption High, Consumption Low, Production High and Production Low can be used for the HC3 Energy Panel

-- The Toon needs to be rooted, see: https://github.com/JackV2020/Root-A-Toon-USB-Stick
-- Recommended all in one solution for a one time boot from USB stick, 10 minutes of work and done. 

-- After rooting you don't need a subscription anymore and you have access to a ToonStore with a growing number of apps. For more technical people there is a possibility to ssh into the Toon if they want with username root and password toon. Rooting is at your own risk, look here for further support and info: 
-- See also: https://github.com/ToonSoftwareCollective/Root-A-Toon (if you already have a running Linux environment)
-- See also: https://toonforum.nl/ 
-- See also: https://www.domoticaforum.eu/


-- Version 1.0 (3th October 2021)
-- Ready for download

-- Version 0.2 (30th September 2021)
-- Gas from m³/h to l/h
-- Splashed a bug

-- Version 0.1 (29th September 2021)
-- Initial version


-- Variables (mandatory): 
-- IPaddress = IP address of your Toon Meter
-- Interval = Number in seconds 
-- debugLevel = Number (1=some, 2=few, 3=all, 4=simulation mode) (default = 1)


-- Example content Json table Toon
--[[
{
  "dev_2": {
    "uuid": "9cf0673f-799f-46b5-88a1-a6bf9d2a663e",
    "name": "HAE_METER_v3",
    "internalAddress": "2",
    "type": "HAE_METER_v3",
    "supportsCrc": "1",
    "ccList": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e",
    "supportedCC": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e",
    "nodeFlags": [],
    "IsConnected": "1",
    "HealthValue": "10",
    "DeviceName": "HAE_METER_v3",
    "CurrentSensorStatus": "UNKNOWN"
  },
  "dev_2.1": {
    "uuid": "e40169ea-c41a-4da7-aec0-768994307e67",
    "name": "HAE_METER_v3_1",
    "internalAddress": "2.1",
    "type": "HAE_METER_v3_1",
    "supportsCrc": "0",
    "ccList": "5e 59 85 8e 3c 3d 3e",
    "supportedCC": "5e 59 85 8e 3c 3d 3e",
    "nodeFlags": [],
    "CurrentSensorStatus": "WARNING",
    "CurrentGasFlow": "71.00",
    "CurrentGasQuantity": "969260.00",
    "DeviceName": "HAE_METER_v3_1"
  },
  "dev_2.2": {
    "uuid": "bbb384e2-63fe-4b1d-b592-70cea5e0188c",
    "name": "HAE_METER_v3_2",
    "internalAddress": "2.2",
    "type": "HAE_METER_v3_2",
    "supportsCrc": "0",
    "ccList": "5e 59 85 8e 3c 3d 3e",
    "supportedCC": "5e 59 85 8e 3c 3d 3e",
    "nodeFlags": [],
    "CurrentSensorStatus": "UNKNOWN",
    "DeviceName": "HAE_METER_v3_2",
    "CurrentElectricityFlow": "NaN",
    "CurrentElectricityQuantity": "NaN"
  },
  "dev_2.3": {
    "uuid": "286c9eea-c9a2-42c6-9fc1-3e1bb271d8c8",
    "name": "HAE_METER_v3_3",
    "internalAddress": "2.3",
    "type": "HAE_METER_v3_3",
    "supportsCrc": "0",
    "ccList": "5e 59 85 8e 3c 3d 3e",
    "supportedCC": "5e 59 85 8e 3c 3d 3e",
    "nodeFlags": [],
    "CurrentSensorStatus": "UNKNOWN",
    "DeviceName": "HAE_METER_v3_3",
    "CurrentElectricityFlow": "NaN",
    "CurrentElectricityQuantity": "NaN"
  },
  "dev_2.4": {
    "uuid": "f665213b-87ae-4faa-accb-03fd863138d8",
    "name": "HAE_METER_v3_4",
    "internalAddress": "2.4",
    "type": "HAE_METER_v3_4",
    "supportsCrc": "0",
    "ccList": "5e 59 85 8e 3c 3d 3e",
    "supportedCC": "5e 59 85 8e 3c 3d 3e",
    "nodeFlags": [],
    "CurrentSensorStatus": "WARNING",
    "DeviceName": "HAE_METER_v3_4",
    "CurrentElectricityFlow": "499.00",
    "CurrentElectricityQuantity": "2356741.00"
  },
  "dev_2.5": {
    "uuid": "41b82ea8-7b8a-4eed-b570-b562fd303ac7",
    "name": "HAE_METER_v3_5",
    "internalAddress": "2.5",
    "type": "HAE_METER_v3_5",
    "supportsCrc": "0",
    "ccList": "5e 59 85 8e 3c 3d 3e",
    "supportedCC": "5e 59 85 8e 3c 3d 3e",
    "nodeFlags": [],
    "CurrentSensorStatus": "UNKNOWN",
    "DeviceName": "HAE_METER_v3_5",
    "CurrentElectricityFlow": "312.00",
    "CurrentElectricityQuantity": "1287325.00"
  },
  "dev_2.6": {
    "uuid": "bffb19a2-6dfa-4c40-906b-1051e7e91a74",
    "name": "HAE_METER_v3_6",
    "internalAddress": "2.6",
    "type": "HAE_METER_v3_6",
    "supportsCrc": "0",
    "ccList": "5e 59 85 8e 3c 3d 3e",
    "supportedCC": "5e 59 85 8e 3c 3d 3e",
    "nodeFlags": [],
    "CurrentSensorStatus": "UNKNOWN",
    "DeviceName": "HAE_METER_v3_6",
    "CurrentElectricityFlow": "0.00",
    "CurrentElectricityQuantity": "1862969.00"
  },
  "dev_2.7": {
    "uuid": "828d2fba-f815-4b20-9ff9-f8ec0fa4e21e",
    "name": "HAE_METER_v3_7",
    "internalAddress": "2.7",
    "type": "HAE_METER_v3_7",
    "supportsCrc": "0",
    "ccList": "5e 59 85 8e 3c 3d 3e",
    "supportedCC": "5e 59 85 8e 3c 3d 3e",
    "nodeFlags": [],
    "CurrentSensorStatus": "UNKNOWN",
    "DeviceName": "HAE_METER_v3_7",
    "CurrentElectricityFlow": "0.00",
    "CurrentElectricityQuantity": "923615.00"
  },
  "dev_2.8": {
    "uuid": "f76e822a-b29e-4007-901f-4cc7d52fbc68",
    "name": "HAE_METER_v3_8",
    "internalAddress": "2.8",
    "type": "HAE_METER_v3_8",
    "supportsCrc": "0",
    "ccList": "5e 59 85 8e 3c 3d 3e",
    "supportedCC": "5e 59 85 8e 3c 3d 3e",
    "nodeFlags": [],
    "CurrentSensorStatus": "UNKNOWN",
    "DeviceName": "HAE_METER_v3_8",
    "CurrentHeatQuantity": "NaN",
    "CurrentHeatFlow": "NaN"
  }
}
-- ]]
  
  
-- No editing of this code is needed 


class 'consumption'(QuickAppChild)
function consumption:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption QuickappChild initiated, deviceId:",self.id)
end
function consumption:updateValue(data) 
  self:updateProperty("value", tonumber(data.Consumption))
  self:updateProperty("power", tonumber(data.Consumption))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "Total: "..string.format("%.0f",data.Consumption_Total) .." kWh")
end


class 'production'(QuickAppChild)
function production:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("production QuickappChild initiated, deviceId:",self.id)
end
function production:updateValue(data) 
  self:updateProperty("value", tonumber(data.Production))
  self:updateProperty("power", tonumber(data.Production))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "Total: "..string.format("%.0f",data.Production_Total) .." kWh")
end


class 'consumption_high'(QuickAppChild)
function consumption_high:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption_high QuickappChild initiated, deviceId:",self.id)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Consumption High child device (" ..self.id ..") to consumption")
  end
end
function consumption_high:updateValue(data) 
  self:updateProperty("value", tonumber(data.Consumption_Total_H))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", " ")
end


class 'consumption_low'(QuickAppChild)
function consumption_low:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption_low QuickappChild initiated, deviceId:",self.id)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Consumption Low child device (" ..self.id ..") to consumption")
  end
end
function consumption_low:updateValue(data) 
  self:updateProperty("value", tonumber(data.Consumption_Total_L))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", " ")
end


class 'production_high'(QuickAppChild)
function production_high:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("production_high QuickappChild initiated, deviceId:",self.id)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Production High child device (" ..self.id ..") to production")
  end
end
function production_high:updateValue(data) 
  self:updateProperty("value", tonumber(data.Production_Total_H))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", " ")
end


class 'production_low'(QuickAppChild)
function production_low:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("production_low QuickappChild initiated, deviceId:",self.id)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Production Low child device (" ..self.id ..") to production")
  end
end
function production_low:updateValue(data) 
  self:updateProperty("value", tonumber(data.Production_Total_L))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", " ")
end


class 'gas'(QuickAppChild)
function gas:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("gas QuickappChild initiated, deviceId:",self.id)
end
function gas:updateValue(data) 
  self:updateProperty("value", tonumber(data.Gas_Usage))
  self:updateProperty("unit", "l/h")
  self:updateProperty("log", " ")
end


class 'total_gas'(QuickAppChild)
function total_gas:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("total_gas QuickappChild initiated, deviceId:",self.id)
end
function total_gas:updateValue(data) 
  self:updateProperty("value", tonumber(data.Gas_Total))
  self:updateProperty("unit", "m³")
  self:updateProperty("log", " ")
end


local function getChildVariable(child,varName)
  for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end


-- QuickApp Functions


function QuickApp:updateChildDevices() -- Update Child Devices
  for id,child in pairs(self.childDevices) do 
    child:updateValue(data) 
  end
end


function QuickApp:logging(level,text) -- Logging function for debug messages
  if tonumber(debugLevel) >= tonumber(level) then 
    self:debug(text)
  end
end


function QuickApp:updateProperties() -- Update the properties
  self:logging(3,"QuickApp:updateProperties")
  self:updateProperty("value", tonumber(data.netConsumption))
  self:updateProperty("power", tonumber(data.netConsumption))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", " ")
end


function QuickApp:updateVariables() -- Update the Variables
  self:logging(3,"QuickApp:updateVariables")

  -- Consumption
  self:setVariable("Consumption",tostring(data.Consumption)) 
  self:setVariable("Consumption_Total_H",tostring(data.Consumption_Total_H)) 
  self:setVariable("Consumption_Total_L",tostring(data.Consumption_Total_L)) 
  self:setVariable("Consumption_Total",tostring(data.Consumption_Total)) 

  -- Production
  self:setVariable("Production",tostring(data.Production))
  self:setVariable("Production_Total_H",tostring(data.Production_Total_H)) 
  self:setVariable("Production_Total_L",tostring(data.Production_Total_L)) 
  self:setVariable("Production_Total",tostring(data.Production_Total)) 

  -- Gas 
  self:setVariable("Gas_Usage",tostring(data.Gas_Usage))
  self:setVariable("Gas_Total",tostring(data.Gas_Total))
  
end


function QuickApp:updateLabels() -- Update the labels
  self:logging(3,"QuickApp:updateLabels")

  local labelText = ""

  labelText = labelText .."Consumption: " ..data.Consumption .." Watt" .."\n"
  labelText = labelText .."Production: " ..data.Production .." Watt" .."\n\n"

  -- High/Low 
  labelText = labelText .."Consumption High: " ..data.Consumption_H .." Watt" .."\n"
  labelText = labelText .."Consumption Low: " ..data.Consumption_L .." Watt" .."\n"
  labelText = labelText .."Production High: " ..data.Production_H .." Watt" .."\n"
  labelText = labelText .."Production Low: " ..data.Production_L .." Watt" .."\n\n"

  -- Consumption Totals 
  labelText = labelText .."Consumption High: "..data.Consumption_Total_H .." kWh" .."\n"
  labelText = labelText .."Consumption Low: "..data.Consumption_Total_L .." kWh" .."\n"
  labelText = labelText .."Consumption Total: "..data.Consumption_Total .." kWh" .."\n\n"

  -- Production Totals
  labelText = labelText .."Production High: "..data.Production_Total_H .." kWh" .."\n"
  labelText = labelText .."Production Low: "..data.Production_Total_L .." kWh" .."\n"
  labelText = labelText .."Production Total: "..data.Production_Total .." kWh" .."\n\n"

  -- Gas Consumption 
  labelText = labelText .."Gas Usage: "..data.Gas_Usage .." l/h" .."\n"
  labelText = labelText .."Gas Total: "..data.Gas_Total .." m³" .."\n\n"
  
  labelText = labelText .."Last Run: "..os.date("%d-%m-%Y %T") .."\n"

  self:updateView("label1", "text", labelText)
  self:logging(2,labelText)
end


function QuickApp:valuesToon() -- Get the values from json file
  self:logging(3,"QuickApp:valuesToon")
  
  -- Consumption
  data.Consumption_H = string.format("%.3f",jsonTable['dev_2.4'].CurrentElectricityFlow)
  data.Consumption_L = string.format("%.3f",jsonTable['dev_2.6'].CurrentElectricityFlow)
  data.Consumption = string.format("%.3f",tonumber(data.Consumption_H)+tonumber(data.Consumption_L))
  data.Consumption_Total_H = string.format("%.1f",tonumber(jsonTable['dev_2.4'].CurrentElectricityQuantity)/1000)
  data.Consumption_Total_L = string.format("%.1f",tonumber(jsonTable['dev_2.6'].CurrentElectricityQuantity)/1000)
  data.Consumption_Total = string.format("%.1f",tonumber(data.Consumption_Total_H)+tonumber(data.Consumption_Total_L))

  -- Production
  data.Production_H = string.format("%.3f",jsonTable['dev_2.5'].CurrentElectricityFlow)
  data.Production_L = string.format("%.3f",jsonTable['dev_2.7'].CurrentElectricityFlow)
  data.Production = string.format("%.3f",tonumber(data.Production_H)+tonumber(data.Production_L))
  data.Production_Total_H = string.format("%.1f",tonumber(jsonTable['dev_2.5'].CurrentElectricityQuantity)/1000)
  data.Production_Total_L = string.format("%.1f",tonumber(jsonTable['dev_2.7'].CurrentElectricityQuantity)/1000)
  data.Production_Total = string.format("%.1f",tonumber(data.Production_Total_H)+tonumber(data.Production_Total_L))
  
  -- Net Consumption/Production
  data.netConsumption = string.format("%.3f",tonumber(data.Consumption) - tonumber(data.Production))

  -- Gas 
  data.Gas_Usage = string.format("%.1f",jsonTable['dev_2.1'].CurrentGasFlow)
  data.Gas_Total = string.format("%.1f",tonumber(jsonTable['dev_2.1'].CurrentGasQuantity)/1000)

end


function QuickApp:simData() -- Simulate Toon
  self:logging(3,"simData")
  apiResult = '{"dev_2": {"uuid": "9cf0673f-799f-46b5-88a1-a6bf9d2a663e", "name": "HAE_METER_v3", "internalAddress": "2", "type": "HAE_METER_v3", "supportsCrc": "1", "ccList": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "supportedCC": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "nodeFlags": [], "IsConnected": "1", "HealthValue": "10", "DeviceName": "HAE_METER_v3", "CurrentSensorStatus": "UNKNOWN"}, "dev_2.1": {"uuid": "e40169ea-c41a-4da7-aec0-768994307e67", "name": "HAE_METER_v3_1", "internalAddress": "2.1", "type": "HAE_METER_v3_1", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "WARNING", "CurrentGasFlow": "71.00", "CurrentGasQuantity": "969260.00", "DeviceName": "HAE_METER_v3_1"}, "dev_2.2": {"uuid": "bbb384e2-63fe-4b1d-b592-70cea5e0188c", "name": "HAE_METER_v3_2", "internalAddress": "2.2", "type": "HAE_METER_v3_2", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_2", "CurrentElectricityFlow": "NaN", "CurrentElectricityQuantity": "NaN"}, "dev_2.3": {"uuid": "286c9eea-c9a2-42c6-9fc1-3e1bb271d8c8", "name": "HAE_METER_v3_3", "internalAddress": "2.3", "type": "HAE_METER_v3_3", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_3", "CurrentElectricityFlow": "NaN", "CurrentElectricityQuantity": "NaN"}, "dev_2.4": {"uuid": "f665213b-87ae-4faa-accb-03fd863138d8", "name": "HAE_METER_v3_4", "internalAddress": "2.4", "type": "HAE_METER_v3_4", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "WARNING", "DeviceName": "HAE_METER_v3_4", "CurrentElectricityFlow": "499.00", "CurrentElectricityQuantity": "2356741.00"}, "dev_2.5": {"uuid": "41b82ea8-7b8a-4eed-b570-b562fd303ac7", "name": "HAE_METER_v3_5", "internalAddress": "2.5", "type": "HAE_METER_v3_5", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_5", "CurrentElectricityFlow": "312.00", "CurrentElectricityQuantity": "1287325.00"}, "dev_2.6": {"uuid": "bffb19a2-6dfa-4c40-906b-1051e7e91a74", "name": "HAE_METER_v3_6", "internalAddress": "2.6", "type": "HAE_METER_v3_6", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_6", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "1862969.00"}, "dev_2.7": {"uuid": "828d2fba-f815-4b20-9ff9-f8ec0fa4e21e", "name": "HAE_METER_v3_7", "internalAddress": "2.7", "type": "HAE_METER_v3_7", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_7", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "923615.00"}, "dev_2.8": {"uuid": "f76e822a-b29e-4007-901f-4cc7d52fbc68", "name": "HAE_METER_v3_8", "internalAddress": "2.8", "type": "HAE_METER_v3_8", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_8", "CurrentHeatQuantity": "NaN", "CurrentHeatFlow": "NaN"}}'
 
  jsonTable = json.decode(apiResult) -- Decode the json string from api to lua-table 

  self:valuesToon() -- Get the values
  self:updateLabels() -- Update the labels
  self:updateProperties() -- Update the properties
  self:updateChildDevices() -- Update the Child Devices
  --self:updateVariables() -- Update the Global Variables Temporarily disabled
  
  self:logging(3,"SetTimeout " ..Interval .." seconds")
  fibaro.setTimeout(Interval*1000, function() 
     self:simData()
  end)
end


function QuickApp:getData() -- Get data from Toon
  self:logging(3,"getData")
  local url = "http://" ..IPaddress ..Path
  self:logging(3,"url: " ..url)
  self.http:request(url, {
  options = {
    headers = {Accept = "application/json"}, method = 'GET'},
    success = function(response)
      self:logging(3,"Response status: " ..response.status)
      self:logging(3,"Response data: " ..response.data)

      local apiResult = response.data        
      jsonTable = json.decode(apiResult) -- Decode the json string from api to lua-table

      self:valuesToon() -- Get the values
      self:updateLabels() -- Update the labels
      self:updateProperties() -- Update the properties
      self:updateChildDevices() -- Update the Child Devices
      --self:updateVariables() -- Update the Global Variables Temporarily disabled

    end,
    error = function(error)
      self:error("error: " ..json.encode(error))
      self:updateProperty("log", "error: " ..json.encode(error))
    end
  }) 
  fibaro.setTimeout(Interval*1000, function() -- Checks every [Interval] seconds for new data
    self:getData()
  end)
end 


function QuickApp:createVariables() -- Get all Quickapp Variables or create them
  Path = "/hdrv_zwave?action=getDevices.json" -- Default path Current

  data = {}
  data.Consumption = ""
  data.Consumption_H = ""
  data.Consumption_L = ""
  data.Consumption_Total = ""
  data.Consumption_Total_H = ""
  data.Consumption_Total_L = ""
  data.Production = ""
  data.Production_H = ""
  data.Production_L = ""
  data.Production_Total = ""
  data.Production_Total_H = ""
  data.Production_Total_L = ""
  data.netConsumption = ""
  data.Gas_Usage = ""
  data.Gas_Total = ""

end


function QuickApp:getQuickappVariables() -- Get all Quickapp Variables or create them
  IPaddress = self:getVariable("IPaddress")
  Interval = tonumber(self:getVariable("Interval")) 
  debugLevel = tonumber(self:getVariable("debugLevel"))

  -- Check existence of the mandatory variables, if not, create them with default values 
  if IPaddress == "" or IPaddress == nil then 
    IPaddress = "192.168.1.50" -- Default IPaddress 
    self:setVariable("IPaddress", IPaddress)
    self:trace("Added QuickApp variable IPaddress")
  end
  if Interval == "" or Interval == nil then
    Interval = "10" -- Default interval in seconds
    self:setVariable("Interval", Interval)
    self:trace("Added QuickApp variable Interval")
    Interval = tonumber(Interval)
  end
  if debugLevel == "" or debugLevel == nil then
    debugLevel = "1" -- Default value for debugLevel
    self:setVariable("debugLevel",debugLevel)
    self:trace("Added QuickApp variable debugLevel")
    debugLevel = tonumber(debugLevel)
  end
  self:logging(3,"Interval: " ..Interval)
end


function QuickApp:setupChildDevices() -- Setup Child Devices
  local cdevs = api.get("/devices?parentId="..self.id) or {} -- Pick up all Child Devices
  function self:initChildDevices() end -- Null function, else Fibaro calls it after onInit()...

  if #cdevs == 0 then -- If no Child Devices, create them
    local initChildData = { 
      {className="consumption", name="Consumption", type="com.fibaro.powerSensor", value=0}, 
      {className="production", name="Production", type="com.fibaro.powerSensor", value=0},
      {className="consumption_high", name="Consumption High", type="com.fibaro.energyMeter", value=0},
      {className="consumption_low", name="Consumption Low", type="com.fibaro.energyMeter", value=0},
      {className="production_high", name="Production High", type="com.fibaro.energyMeter", value=0},
      {className="production_low", name="Production Low", type="com.fibaro.energyMeter", value=0},
      {className="gas", name="Gas", type="com.fibaro.multilevelSensor", value=0},
      {className="total_gas", name="Gas Total", type="com.fibaro.multilevelSensor", value=0},
    }
    for _,c in ipairs(initChildData) do
      local child = self:createChildDevice(
        {name = c.name,
          type=c.type,
          value=c.value,
          unit=c.unit,
          initialInterfaces = {},
        },
        _G[c.className] -- Fetch class constructor from class name
      )
      child:setVariable("className",c.className)  -- Save class name so we know when we load it next time
    end   
  else 
    for _,child in ipairs(cdevs) do
      local className = getChildVariable(child,"className") -- Fetch child class name
      local childObject = _G[className](child) -- Create child object from the constructor name
      self.childDevices[child.id]=childObject
      childObject.parent = self -- Setup parent link to device controller 
    end
  end
end


function QuickApp:onInit()
  __TAG = fibaro.getName(plugin.mainDeviceId) .." ID:" ..plugin.mainDeviceId
  self.http = net.HTTPClient({timeout=3000})
  self:debug("onInit")
  self:setupChildDevices() -- Setup the Child Devices 
  self:getQuickappVariables() -- Get Quickapp Variables or create them
  self:createVariables() -- Create Variables
    
  if tonumber(debugLevel) >= 4 then 
    self:simData() -- Go in simulation
  else
    self:getData() -- Get data
  end
    
end

-- EOF
