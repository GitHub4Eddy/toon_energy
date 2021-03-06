-- QUICKAPP TOON ENERGY

-- This Quickapp retrieves energy consumption, energy production and gas usage from the Toon Energymeter (version 1 or 2)

-- This QuickApp has Child Devices for Consumption (Watt), Production (Watt), Consumption High (kWh), Consumption Low (kWh), Production High (kWh), Production Low (kWh), Production Actual (Watt), Gas Usage (l/h) and Total Gas (m³)

-- The Energy Usage from the Child devices Consumption High, Consumption Low, Production High and Production Low can be used for the HC3 Energy Panel

-- The Toon needs to be rooted, see: https://github.com/JackV2020/Root-A-Toon-USB-Stick
-- Recommended all in one solution for a one time boot from USB stick, 10 minutes of work and done. 

-- After rooting you don't need a subscription anymore and you have access to a ToonStore with a growing number of apps. For more technical people there is a possibility to ssh into the Toon if they want with username root and password toon. Rooting is at your own risk, look here for further support and info: 
-- See also: https://github.com/ToonSoftwareCollective/Root-A-Toon (if you already have a running Linux environment)
-- See also: https://toonforum.nl/ 
-- See also: https://www.domoticaforum.eu/


-- Version 1.3 (20th February 2022)
-- Solved issue with "NaN" responses or other bad responses from Toon Energy
-- Added child device voor actual solar production


-- Version 1.2 (27th December 2021)
-- Solved code error with toonVersion

-- Version 1.1 (27th December 2021)
-- Added support for Toon version 1
-- Added Simulation notice in labels

-- Version 1.0 (3th October 2021)
-- Ready for download

-- Version 0.2 (30th September 2021)
-- Gas from m³/h to l/h
-- Splashed a bug

-- Version 0.1 (29th September 2021)
-- Initial version


-- Variables (mandatory): 
-- IPaddress = IP address of your Toon Meter
-- toonVersion = Version 1 or 2 (default)
-- Interval = Number in seconds 
-- debugLevel = Number (1=some, 2=few, 3=all, 4=simulation mode) (default = 1)
  
  
-- No editing of this code is needed 


class 'consumption'(QuickAppChild)
function consumption:__init(dev)
  QuickAppChild.__init(self,dev)
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


class 'production_act'(QuickAppChild)
function production_act:__init(dev)
  QuickAppChild.__init(self,dev)
end
function production_act:updateValue(data) 
  self:updateProperty("value", tonumber(data.Production_Act))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", " ")
end


class 'gas'(QuickAppChild)
function gas:__init(dev)
  QuickAppChild.__init(self,dev)
end
function gas:updateValue(data) 
  self:updateProperty("value", tonumber(data.Gas_Usage))
  self:updateProperty("unit", "l/h")
  self:updateProperty("log", " ")
end


class 'total_gas'(QuickAppChild)
function total_gas:__init(dev)
  QuickAppChild.__init(self,dev)
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
  self:updateProperty("log", os.date("%d-%m-%Y %T"))
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
  if debugLevel == 4 then
    labelText = labelText .."SIMULATION MODE" .."\n\n"
  end
  
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
  labelText = labelText .."Production Total: "..data.Production_Total .." kWh" .."\n"
  labelText = labelText .."Production Actual: " ..data.Production_Act .." Watt" .."\n\n"

  -- Gas Consumption 
  labelText = labelText .."Gas Usage: "..data.Gas_Usage .." l/h" .."\n"
  labelText = labelText .."Gas Total: "..data.Gas_Total .." m³" .."\n\n"
  
  labelText = labelText .."Last Run: "..os.date("%d-%m-%Y %T") .."\n"

  self:updateView("label1", "text", labelText)
  self:logging(2,labelText)
end


function QuickApp:valuesToonOne() -- Get the values from json file Toon version One
  self:logging(3,"QuickApp:valuesToon")
  
  -- Consumption
  data.Consumption_H = string.format("%.3f",jsonTable['dev_10.4'].CurrentElectricityFlow)
  data.Consumption_L = string.format("%.3f",jsonTable['dev_10.6'].CurrentElectricityFlow)
  data.Consumption = string.format("%.3f",tonumber(data.Consumption_H)+tonumber(data.Consumption_L))
  data.Consumption_Total_H = string.format("%.1f",tonumber(jsonTable['dev_10.4'].CurrentElectricityQuantity)/1000)
  data.Consumption_Total_L = string.format("%.1f",tonumber(jsonTable['dev_10.6'].CurrentElectricityQuantity)/1000)
  data.Consumption_Total = string.format("%.1f",tonumber(data.Consumption_Total_H)+tonumber(data.Consumption_Total_L))

  -- Production
  data.Production_H = string.format("%.3f",jsonTable['dev_10.5'].CurrentElectricityFlow)
  data.Production_L = string.format("%.3f",jsonTable['dev_10.7'].CurrentElectricityFlow)
  data.Production = string.format("%.3f",tonumber(data.Production_H)+tonumber(data.Production_L))
  data.Production_Total_H = string.format("%.1f",tonumber(jsonTable['dev_10.5'].CurrentElectricityQuantity)/1000)
  data.Production_Total_L = string.format("%.1f",tonumber(jsonTable['dev_10.7'].CurrentElectricityQuantity)/1000)
  data.Production_Total = string.format("%.1f",tonumber(data.Production_Total_H)+tonumber(data.Production_Total_L))
  data.Production_Act = string.format("%.3f",jsonTable['dev_10.3'].CurrentElectricityQuantity)

  -- Net Consumption/Production
  data.netConsumption = string.format("%.3f",tonumber(data.Consumption) - tonumber(data.Production))

  -- Gas 
  data.Gas_Usage = string.format("%.1f",jsonTable['dev_10.1'].CurrentGasFlow)
  data.Gas_Total = string.format("%.1f",tonumber(jsonTable['dev_10.1'].CurrentGasQuantity)/1000)

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
  data.Production_Act = string.format("%.3f",jsonTable['dev_2.3'].CurrentElectricityQuantity)
  
  -- Net Consumption/Production
  data.netConsumption = string.format("%.3f",tonumber(data.Consumption) - tonumber(data.Production))

  -- Gas 
  data.Gas_Usage = string.format("%.1f",jsonTable['dev_2.1'].CurrentGasFlow)
  data.Gas_Total = string.format("%.1f",tonumber(jsonTable['dev_2.1'].CurrentGasQuantity)/1000)

end


function QuickApp:simData() -- Simulate Toon
  self:logging(3,"simData")
  if toonVersion == "2" then 
    apiResult = '{"dev_2": {"uuid": "9cf0673f-799f-46b5-88a1-a6bf9d2a663e", "name": "HAE_METER_v3", "internalAddress": "2", "type": "HAE_METER_v3", "supportsCrc": "1", "ccList": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "supportedCC": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "nodeFlags": [], "IsConnected": "1", "HealthValue": "10", "DeviceName": "HAE_METER_v3", "CurrentSensorStatus": "UNKNOWN"}, "dev_2.1": {"uuid": "e40169ea-c41a-4da7-aec0-768994307e67", "name": "HAE_METER_v3_1", "internalAddress": "2.1", "type": "HAE_METER_v3_1", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "WARNING", "CurrentGasFlow": "71.00", "CurrentGasQuantity": "969260.00", "DeviceName": "HAE_METER_v3_1"}, "dev_2.2": {"uuid": "bbb384e2-63fe-4b1d-b592-70cea5e0188c", "name": "HAE_METER_v3_2", "internalAddress": "2.2", "type": "HAE_METER_v3_2", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_2", "CurrentElectricityFlow": "0", "CurrentElectricityQuantity": "0"}, "dev_2.3": {"uuid": "286c9eea-c9a2-42c6-9fc1-3e1bb271d8c8", "name": "HAE_METER_v3_3", "internalAddress": "2.3", "type": "HAE_METER_v3_3", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_3", "CurrentElectricityFlow": "0", "CurrentElectricityQuantity": "0"}, "dev_2.4": {"uuid": "f665213b-87ae-4faa-accb-03fd863138d8", "name": "HAE_METER_v3_4", "internalAddress": "2.4", "type": "HAE_METER_v3_4", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "WARNING", "DeviceName": "HAE_METER_v3_4", "CurrentElectricityFlow": "499.00", "CurrentElectricityQuantity": "2356741.00"}, "dev_2.5": {"uuid": "41b82ea8-7b8a-4eed-b570-b562fd303ac7", "name": "HAE_METER_v3_5", "internalAddress": "2.5", "type": "HAE_METER_v3_5", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_5", "CurrentElectricityFlow": "312.00", "CurrentElectricityQuantity": "1287325.00"}, "dev_2.6": {"uuid": "bffb19a2-6dfa-4c40-906b-1051e7e91a74", "name": "HAE_METER_v3_6", "internalAddress": "2.6", "type": "HAE_METER_v3_6", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_6", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "1862969.00"}, "dev_2.7": {"uuid": "828d2fba-f815-4b20-9ff9-f8ec0fa4e21e", "name": "HAE_METER_v3_7", "internalAddress": "2.7", "type": "HAE_METER_v3_7", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_7", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "923615.00"}, "dev_2.8": {"uuid": "f76e822a-b29e-4007-901f-4cc7d52fbc68", "name": "HAE_METER_v3_8", "internalAddress": "2.8", "type": "HAE_METER_v3_8", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_8", "CurrentHeatQuantity": "0", "CurrentHeatFlow": "0"}}'
  else
    apiResult = '{"dev_settings_device": {"uuid": "17f709f0-dbb1-4081-808b-2152cf7622b5", "name": "settings_device", "internalAddress": "settings_device", "type": "settings_device"}, "dev_3": {"uuid": "bf979010-40ff-429d-ade3-9e272f4976d0", "name": "cv boven", "internalAddress": "3", "type": "FGWP011", "supportsCrc": "0", "ccList": "72 86 70 85 8e 25 73 32 31 7a", "supportedCC": "72 86 70 85 8e 25 73 32 31 7a", "nodeFlags": [], "TargetStatus": "1", "CurrentElectricityFlow": "3.20", "CurrentElectricityQuantity": "477620.00", "IsConnected": "1", "HealthValue": "10", "DeviceName": "cv boven"}, "dev_4": {"uuid": "b14e07b2-0b6b-4e59-8f51-2956f805261b", "name": "FGWP011", "internalAddress": "4", "type": "FGWP011", "supportsCrc": "0", "ccList": "72 86 70 85 8e 25 73 32 31 7a", "supportedCC": "72 86 70 85 8e 25 73 32 31 7a", "nodeFlags": [], "TargetStatus": "1", "CurrentElectricityFlow": "0.70", "CurrentElectricityQuantity": "601520.00", "IsConnected": "1", "HealthValue": "-1", "DeviceName": "FGWP011"}, "dev_10": {"uuid": "060d70a3-7362-4dd9-8509-06ee97b82546", "name": "HAE_METER_v3", "internalAddress": "10", "type": "HAE_METER_v3", "supportsCrc": "1", "ccList": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "supportedCC": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "nodeFlags": [], "IsConnected": "1", "HealthValue": "-1", "DeviceName": "HAE_METER_v3", "CurrentSensorStatus": "UNKNOWN"}, "dev_10.1": {"uuid": "9c804ca1-9139-42de-b5fe-a1b7266ab8d9", "name": "HAE_METER_v3_1", "internalAddress": "10.1", "type": "gas", "supportsCrc": "0", "nodeFlags": [], "CurrentGasFlow": "581.00", "CurrentGasQuantity": "7277954.00", "DeviceName": "HAE_METER_v3_1"}, "dev_10.2": {"uuid": "ee17f68e-8786-4708-a622-2ac201448266", "name": "HAE_METER_v3_2", "internalAddress": "10.2", "type": "elec", "supportsCrc": "0", "nodeFlags": [], "CurrentElectricityFlow": "0", "CurrentElectricityQuantity": "0", "DeviceName": "HAE_METER_v3_2"}, "dev_10.3": {"uuid": "834b1da5-0a15-446f-8ae6-15cf255230e5", "name": "HAE_METER_v3_3", "internalAddress": "10.3", "type": "elec_solar", "supportsCrc": "0", "nodeFlags": [], "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "0.00", "DeviceName": "HAE_METER_v3_3"}, "dev_10.4": {"uuid": "0a16a44e-648e-4b1a-b0eb-752af278dd9a", "name": "HAE_METER_v3_4", "internalAddress": "10.4", "type": "elec_delivered_nt", "supportsCrc": "0", "nodeFlags": [], "CurrentElectricityFlow": "326.00", "CurrentElectricityQuantity": "10670267.00", "DeviceName": "HAE_METER_v3_4"}, "dev_10.5": {"uuid": "7bbb4598-3288-4a12-931c-f839c2aca8b9", "name": "HAE_METER_v3_5", "internalAddress": "10.5", "type": "elec_received_nt", "supportsCrc": "0", "nodeFlags": [], "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "4747586.00", "DeviceName": "HAE_METER_v3_5"}, "dev_10.6": {"uuid": "9c0a2fbd-526f-41ae-ade8-7ed7e0d42bce", "name": "HAE_METER_v3_6", "internalAddress": "10.6", "type": "elec_delivered_lt", "supportsCrc": "0", "nodeFlags": [], "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "11662485.00", "DeviceName": "HAE_METER_v3_6"}, "dev_10.7": {"uuid": "e87a8157-dfcf-4403-aab1-ced37e99b529", "name": "HAE_METER_v3_7", "internalAddress": "10.7", "type": "elec_received_lt", "supportsCrc": "0", "nodeFlags": [], "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "1839937.00", "DeviceName": "HAE_METER_v3_7"}, "dev_10.8": {"uuid": "c29b354f-0faf-4e29-8249-949d0d0aa3b6", "name": "HAE_METER_v3_8", "internalAddress": "10.8", "type": "heat", "supportsCrc": "0", "nodeFlags": [], "CurrentHeatQuantity": "0", "DeviceName": "HAE_METER_v3_8"}, "dev_15": {"uuid": "1095b3a3-c3c8-4a1b-b8f7-8247835c50fd", "name": "vaatwasser", "internalAddress": "15", "type": "FGWPF102", "supportsCrc": "1", "ccList": "5e 22 85 59 70 56 5a 7a 72 32 8e 71 73 98 31 25 86", "supportedCC": "5e 22 85 59 70 56 5a 7a 72 32 8e 71 73 98 31 25 86", "nodeFlags": [], "IsConnected": "1", "DeviceName": "vaatwasser", "TargetStatus": "1", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "844600.00", "HealthValue": "-1"}}'
  end
  
  apiResult = apiResult:gsub("NaN", "0") -- clean up the response.data by replacing NaN with 0
  --self:logging(3,"Response data withoot null: " ..response.data)
  jsonTable = json.decode(apiResult) -- Decode the json string from api to lua-table 

  if toonVersion == "2" then 
    self:valuesToon() -- Get the values for Toon version Two
  else
    self:valuesToonOne() -- Get the values for version Toon One
  end
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

      if response.data == nil or response.data == "" or response.data == "[]" or response.status > 200 then -- Check for empty result
        self:warning("Temporarily no production data from Toon Energy")
        return
      end

      response.data = response.data:gsub("NaN", "0") -- clean up the response.data by replacing NaN with 0
      --self:logging(3,"Response data withoot null: " ..response.data)
      
      jsonTable = json.decode(response.data) -- Decode the json string from api to lua-table

      if toonVersion == "2" then 
        self:valuesToon() -- Get the values for Toon version Two
      else
        self:valuesToonOne() -- Get the values for version Toon One
      end
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


function QuickApp:createVariables() -- Create all Variables
  self:logging(3,"Start createVariables")
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
  data.Production_Act = ""
  data.Gas_Usage = ""
  data.Gas_Total = ""

end


function QuickApp:getQuickappVariables() -- Get all Quickapp Variables or create them
  IPaddress = self:getVariable("IPaddress")
  toonVersion = self:getVariable("toonVersion")
  Interval = tonumber(self:getVariable("Interval")) 
  debugLevel = tonumber(self:getVariable("debugLevel"))

  -- Check existence of the mandatory variables, if not, create them with default values 
  if IPaddress == "" or IPaddress == nil then 
    IPaddress = "192.168.1.50" -- Default IPaddress 
    self:setVariable("IPaddress", IPaddress)
    self:trace("Added QuickApp variable IPaddress")
  end
  if toonVersion == "" or toonVersion == nil then 
    toonVersion = "2" -- Default Toon Version 
    self:setVariable("toonVersion", toonVersion)
    self:trace("Added QuickApp variable toonVersion")
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
      {className="production_act", name="Production Actual", type="com.fibaro.powerSensor", value=0}, 
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
  
  if not api.get("/devices/"..self.id).enabled then
    self:warning("Device", fibaro.getName(plugin.mainDeviceId), "is disabled")
    return
  end
  
  self:getQuickappVariables() -- Get Quickapp Variables or create them
  self:createVariables() -- Create Variables
    
  if tonumber(debugLevel) >= 4 then 
    self:simData() -- Go in simulation
  else
    self:getData() -- Get data
  end
    
end

-- EOF
