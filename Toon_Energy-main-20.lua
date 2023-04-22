-- Toon Energy main


local function getChildVariable(child,varName)
  for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end


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
  self:logging(3,"updateProperties - Update the properties")
  self:updateProperty("value", tonumber(data.netConsumption))
  self:updateProperty("power", tonumber(data.netConsumption))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", os.date("%d-%m-%Y %T"))
end


function QuickApp:updateVariables() -- Update the Variables
  self:logging(3,"updateVariables - Update the Variables")

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
  self:logging(3,"updateLabels() - Update the labels")

  local labelText = ""
  if debugLevel == 4 then
    labelText = labelText ..translation["SIMULATION MODE"] .."\n\n"
  end
  
  labelText = labelText ..translation["Consumption"] ..": " ..data.Consumption .." Watt" .."\n"
  labelText = labelText ..translation["Production"] ..": " ..data.Production .." Watt" .."\n\n"

  -- High/Low 
  labelText = labelText ..translation["Consumption High"] ..": " ..data.Consumption_H .." Watt" .."\n"
  labelText = labelText ..translation["Consumption Low"] ..": " ..data.Consumption_L .." Watt" .."\n"
  labelText = labelText ..translation["Production High"] ..": " ..data.Production_H .." Watt" .."\n"
  labelText = labelText ..translation["Production Low"] ..": " ..data.Production_L .." Watt" .."\n\n"

  -- Consumption Totals 
  labelText = labelText ..translation["Consumption High"] ..": "..data.Consumption_Total_H .." kWh" .."\n"
  labelText = labelText ..translation["Consumption Low"] ..": "..data.Consumption_Total_L .." kWh" .."\n"
  labelText = labelText ..translation["Consumption Total"] ..": "..data.Consumption_Total .." kWh" .."\n\n"

  -- Production Totals
  labelText = labelText ..translation["Production High"] ..": "..data.Production_Total_H .." kWh" .."\n"
  labelText = labelText ..translation["Production Low"] ..": "..data.Production_Total_L .." kWh" .."\n"
  labelText = labelText ..translation["Production Total"] ..": "..data.Production_Total .." kWh" .."\n"
  labelText = labelText ..translation["Production Actual"] ..": " ..data.Production_Act .." Watt" .."\n\n"

  -- Gas Consumption 
  labelText = labelText ..translation["Gas Usage"] ..": "..data.Gas_Usage .." l/h" .."\n"
  labelText = labelText ..translation["Gas Total"] ..": "..data.Gas_Total .." m³" .."\n\n"
  
  labelText = labelText ..translation["Last Run"] ..": "..os.date("%d-%m-%Y %T") .."\n"

  self:updateView("label1", "text", labelText)
  self:logging(2,labelText)
end


function QuickApp:valuesToonOne() -- Get the values from json file Toon version 1
  self:logging(3,"valuesToonOne() - Get the values from json file Toon version 1")
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


function QuickApp:valuesToon2v2() -- Get the values from json file Toon version 2v2
  self:logging(3,"valuesToon2v2() - Get the values from json file Toon version 2v2")
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


function QuickApp:valuesToon2v3() -- Get the values from json file Toon version 2v3
  self:logging(3,"valuesToon2v3() - Get the values from json file Toon version 2v3")
  -- Consumption
  data.Consumption_H = string.format("%.3f",jsonTable['dev_3.4'].CurrentElectricityFlow)
  data.Consumption_L = string.format("%.3f",jsonTable['dev_3.6'].CurrentElectricityFlow)
  data.Consumption = string.format("%.3f",tonumber(data.Consumption_H)+tonumber(data.Consumption_L))
  data.Consumption_Total_H = string.format("%.1f",tonumber(jsonTable['dev_3.4'].CurrentElectricityQuantity)/1000)
  data.Consumption_Total_L = string.format("%.1f",tonumber(jsonTable['dev_3.6'].CurrentElectricityQuantity)/1000)
  data.Consumption_Total = string.format("%.1f",tonumber(data.Consumption_Total_H)+tonumber(data.Consumption_Total_L))
  -- Production
  data.Production_H = string.format("%.3f",jsonTable['dev_3.5'].CurrentElectricityFlow)
  data.Production_L = string.format("%.3f",jsonTable['dev_3.7'].CurrentElectricityFlow)
  data.Production = string.format("%.3f",tonumber(data.Production_H)+tonumber(data.Production_L))
  data.Production_Total_H = string.format("%.1f",tonumber(jsonTable['dev_3.5'].CurrentElectricityQuantity)/1000)
  data.Production_Total_L = string.format("%.1f",tonumber(jsonTable['dev_3.7'].CurrentElectricityQuantity)/1000)
  data.Production_Total = string.format("%.1f",tonumber(data.Production_Total_H)+tonumber(data.Production_Total_L))
  data.Production_Act = string.format("%.3f",jsonTable['dev_3.3'].CurrentElectricityQuantity)
  -- Net Consumption/Production
  data.netConsumption = string.format("%.3f",tonumber(data.Consumption) - tonumber(data.Production))
  -- Gas 
  data.Gas_Usage = string.format("%.1f",jsonTable['dev_3.1'].CurrentGasFlow)
  data.Gas_Total = string.format("%.1f",tonumber(jsonTable['dev_3.1'].CurrentGasQuantity)/1000)
end


function QuickApp:valuesToon2v4() -- Get the values from json file Toon version 2v4
  self:logging(3,"valuesToon2v6() - Get the values from json file Toon version 2v4")
  -- Consumption
  data.Consumption_H = string.format("%.3f",jsonTable['dev_4.4'].CurrentElectricityFlow)
  data.Consumption_L = string.format("%.3f",jsonTable['dev_4.6'].CurrentElectricityFlow)
  data.Consumption = string.format("%.3f",tonumber(data.Consumption_H)+tonumber(data.Consumption_L))
  data.Consumption_Total_H = string.format("%.1f",tonumber(jsonTable['dev_4.4'].CurrentElectricityQuantity)/1000)
  data.Consumption_Total_L = string.format("%.1f",tonumber(jsonTable['dev_4.6'].CurrentElectricityQuantity)/1000)
  data.Consumption_Total = string.format("%.1f",tonumber(data.Consumption_Total_H)+tonumber(data.Consumption_Total_L))
  -- Production
  data.Production_H = string.format("%.3f",jsonTable['dev_4.5'].CurrentElectricityFlow)
  data.Production_L = string.format("%.3f",jsonTable['dev_4.7'].CurrentElectricityFlow)
  data.Production = string.format("%.3f",tonumber(data.Production_H)+tonumber(data.Production_L))
  data.Production_Total_H = string.format("%.1f",tonumber(jsonTable['dev_4.5'].CurrentElectricityQuantity)/1000)
  data.Production_Total_L = string.format("%.1f",tonumber(jsonTable['dev_4.7'].CurrentElectricityQuantity)/1000)
  data.Production_Total = string.format("%.1f",tonumber(data.Production_Total_H)+tonumber(data.Production_Total_L))
  data.Production_Act = string.format("%.3f",jsonTable['dev_4.3'].CurrentElectricityQuantity)
  -- Net Consumption/Production
  data.netConsumption = string.format("%.3f",tonumber(data.Consumption) - tonumber(data.Production))
  -- Gas 
  data.Gas_Usage = string.format("%.1f",jsonTable['dev_4.1'].CurrentGasFlow)
  data.Gas_Total = string.format("%.1f",tonumber(jsonTable['dev_4.1'].CurrentGasQuantity)/1000)
end


function QuickApp:valuesToon2v5() -- Get the values from json file Toon version 2v5
  self:logging(3,"valuesToon2v5() - Get the values from json file Toon version 2v5")
  -- Consumption
  data.Consumption_H = string.format("%.3f",jsonTable['dev_5.4'].CurrentElectricityFlow)
  data.Consumption_L = string.format("%.3f",jsonTable['dev_5.6'].CurrentElectricityFlow)
  data.Consumption = string.format("%.3f",tonumber(data.Consumption_H)+tonumber(data.Consumption_L))
  data.Consumption_Total_H = string.format("%.1f",tonumber(jsonTable['dev_5.4'].CurrentElectricityQuantity)/1000)
  data.Consumption_Total_L = string.format("%.1f",tonumber(jsonTable['dev_5.6'].CurrentElectricityQuantity)/1000)
  data.Consumption_Total = string.format("%.1f",tonumber(data.Consumption_Total_H)+tonumber(data.Consumption_Total_L))
  -- Production
  data.Production_H = string.format("%.3f",jsonTable['dev_5.5'].CurrentElectricityFlow)
  data.Production_L = string.format("%.3f",jsonTable['dev_5.7'].CurrentElectricityFlow)
  data.Production = string.format("%.3f",tonumber(data.Production_H)+tonumber(data.Production_L))
  data.Production_Total_H = string.format("%.1f",tonumber(jsonTable['dev_5.5'].CurrentElectricityQuantity)/1000)
  data.Production_Total_L = string.format("%.1f",tonumber(jsonTable['dev_5.7'].CurrentElectricityQuantity)/1000)
  data.Production_Total = string.format("%.1f",tonumber(data.Production_Total_H)+tonumber(data.Production_Total_L))
  data.Production_Act = string.format("%.3f",jsonTable['dev_5.3'].CurrentElectricityQuantity)
  -- Net Consumption/Production
  data.netConsumption = string.format("%.3f",tonumber(data.Consumption) - tonumber(data.Production))
  -- Gas 
  data.Gas_Usage = string.format("%.1f",jsonTable['dev_5.1'].CurrentGasFlow)
  data.Gas_Total = string.format("%.1f",tonumber(jsonTable['dev_5.1'].CurrentGasQuantity)/1000)
end


function QuickApp:valuesToon2v6() -- Get the values from json file Toon version 2v6
  self:logging(3,"valuesToon2v6() - Get the values from json file Toon version 2v6")
  -- Consumption
  data.Consumption_H = string.format("%.3f",jsonTable['dev_6.4'].CurrentElectricityFlow)
  data.Consumption_L = string.format("%.3f",jsonTable['dev_6.6'].CurrentElectricityFlow)
  data.Consumption = string.format("%.3f",tonumber(data.Consumption_H)+tonumber(data.Consumption_L))
  data.Consumption_Total_H = string.format("%.1f",tonumber(jsonTable['dev_6.4'].CurrentElectricityQuantity)/1000)
  data.Consumption_Total_L = string.format("%.1f",tonumber(jsonTable['dev_6.6'].CurrentElectricityQuantity)/1000)
  data.Consumption_Total = string.format("%.1f",tonumber(data.Consumption_Total_H)+tonumber(data.Consumption_Total_L))
  -- Production
  data.Production_H = string.format("%.3f",jsonTable['dev_6.5'].CurrentElectricityFlow)
  data.Production_L = string.format("%.3f",jsonTable['dev_6.7'].CurrentElectricityFlow)
  data.Production = string.format("%.3f",tonumber(data.Production_H)+tonumber(data.Production_L))
  data.Production_Total_H = string.format("%.1f",tonumber(jsonTable['dev_6.5'].CurrentElectricityQuantity)/1000)
  data.Production_Total_L = string.format("%.1f",tonumber(jsonTable['dev_6.7'].CurrentElectricityQuantity)/1000)
  data.Production_Total = string.format("%.1f",tonumber(data.Production_Total_H)+tonumber(data.Production_Total_L))
  data.Production_Act = string.format("%.3f",jsonTable['dev_6.3'].CurrentElectricityQuantity)
  -- Net Consumption/Production
  data.netConsumption = string.format("%.3f",tonumber(data.Consumption) - tonumber(data.Production))
  -- Gas 
  data.Gas_Usage = string.format("%.1f",jsonTable['dev_6.1'].CurrentGasFlow)
  data.Gas_Total = string.format("%.1f",tonumber(jsonTable['dev_6.1'].CurrentGasQuantity)/1000)
end


function QuickApp:simData() -- Simulate Toon
  self:logging(3,"simData() - Simulate Toon")
  if toonVersion == "2v2" or toonVersion == "2" then -- Toon version 2v2
    apiResult = '{"dev_2": {"uuid": "9cf0673f-799f-46b5-88a1-a6bf9d2a663e", "name": "HAE_METER_v3", "internalAddress": "2", "type": "HAE_METER_v3", "supportsCrc": "1", "ccList": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "supportedCC": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "nodeFlags": [], "IsConnected": "1", "HealthValue": "10", "DeviceName": "HAE_METER_v3", "CurrentSensorStatus": "UNKNOWN"}, "dev_2.1": {"uuid": "e40169ea-c41a-4da7-aec0-768994307e67", "name": "HAE_METER_v3_1", "internalAddress": "2.1", "type": "HAE_METER_v3_1", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "WARNING", "CurrentGasFlow": "71.00", "CurrentGasQuantity": "969260.00", "DeviceName": "HAE_METER_v3_1"}, "dev_2.2": {"uuid": "bbb384e2-63fe-4b1d-b592-70cea5e0188c", "name": "HAE_METER_v3_2", "internalAddress": "2.2", "type": "HAE_METER_v3_2", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_2", "CurrentElectricityFlow": "0", "CurrentElectricityQuantity": "0"}, "dev_2.3": {"uuid": "286c9eea-c9a2-42c6-9fc1-3e1bb271d8c8", "name": "HAE_METER_v3_3", "internalAddress": "2.3", "type": "HAE_METER_v3_3", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_3", "CurrentElectricityFlow": "0", "CurrentElectricityQuantity": "0"}, "dev_2.4": {"uuid": "f665213b-87ae-4faa-accb-03fd863138d8", "name": "HAE_METER_v3_4", "internalAddress": "2.4", "type": "HAE_METER_v3_4", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "WARNING", "DeviceName": "HAE_METER_v3_4", "CurrentElectricityFlow": "499.00", "CurrentElectricityQuantity": "2356741.00"}, "dev_2.5": {"uuid": "41b82ea8-7b8a-4eed-b570-b562fd303ac7", "name": "HAE_METER_v3_5", "internalAddress": "2.5", "type": "HAE_METER_v3_5", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_5", "CurrentElectricityFlow": "312.00", "CurrentElectricityQuantity": "1287325.00"}, "dev_2.6": {"uuid": "bffb19a2-6dfa-4c40-906b-1051e7e91a74", "name": "HAE_METER_v3_6", "internalAddress": "2.6", "type": "HAE_METER_v3_6", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_6", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "1862969.00"}, "dev_2.7": {"uuid": "828d2fba-f815-4b20-9ff9-f8ec0fa4e21e", "name": "HAE_METER_v3_7", "internalAddress": "2.7", "type": "HAE_METER_v3_7", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_7", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "923615.00"}, "dev_2.8": {"uuid": "f76e822a-b29e-4007-901f-4cc7d52fbc68", "name": "HAE_METER_v3_8", "internalAddress": "2.8", "type": "HAE_METER_v3_8", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_8", "CurrentHeatQuantity": "0", "CurrentHeatFlow": "0"}}'
  elseif toonVersion == "2v3" then -- Toon version 2v3
    apiResult = '{"dev_settings_device": {"uuid": "7e8ba3a4-a47a-450f-945b-f582daa00824", "name": "settings_device", "internalAddress": "settings_device", "type": "settings_device"}, "dev_3": {"uuid": "4e7ea85a-efe8-4ad2-ade2-63561eef2cfd", "name": "HAE_METER_v3", "internalAddress": "3", "type": "HAE_METER_v3", "supportsCrc": "1", "ccList": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "supportedCC": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "nodeFlags": [], "IsConnected": "1", "HealthValue": "10", "DeviceName": "HAE_METER_v3", "CurrentSensorStatus": "UNKNOWN"}, "dev_3.1": {"uuid": "c82952a1-422e-495c-b98b-30ae488f99fe", "name": "HAE_METER_v3_1", "internalAddress": "3.1", "type": "HAE_METER_v3_1", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "WARNING", "DeviceName": "HAE_METER_v3_1", "CurrentGasFlow": "104.00", "CurrentGasQuantity": "9137836.00"}, "dev_3.2": {"uuid": "ff31cb7f-fefe-4df3-a349-709f7d79a149", "name": "HAE_METER_v3_2", "internalAddress": "3.2", "type": "HAE_METER_v3_2", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_2", "CurrentElectricityFlow": "NaN", "CurrentElectricityQuantity": "NaN"}, "dev_3.3": {"uuid": "54d44628-f538-4819-a1b8-7b1bb92b05a6", "name": "HAE_METER_v3_3", "internalAddress": "3.3", "type": "HAE_METER_v3_3", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_3", "CurrentElectricityFlow": "NaN", "CurrentElectricityQuantity": "NaN"}, "dev_3.4": {"uuid": "7ce94a24-7184-45eb-987e-7b184f5bf6b8", "name": "HAE_METER_v3_4", "internalAddress": "3.4", "type": "HAE_METER_v3_4", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "WARNING", "DeviceName": "HAE_METER_v3_4", "CurrentElectricityFlow": "5436.00", "CurrentElectricityQuantity": "21083222.00"}, "dev_3.5": {"uuid": "7fc5cfd9-5de1-4152-882c-28e97549ad4e", "name": "HAE_METER_v3_5", "internalAddress": "3.5", "type": "HAE_METER_v3_5", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_5", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "1034029.00"}, "dev_3.6": {"uuid": "65858220-d550-4f03-b423-4376baa49859", "name": "HAE_METER_v3_6", "internalAddress": "3.6", "type": "HAE_METER_v3_6", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_6", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "12789580.00"}, "dev_3.7": {"uuid": "8062d998-cb7a-4fec-95ca-fef93fa52618", "name": "HAE_METER_v3_7", "internalAddress": "3.7", "type": "HAE_METER_v3_7", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_7", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "1833545.00"}, "dev_3.8": {"uuid": "093102cf-fa80-4b42-b1ec-d879658b274e", "name": "HAE_METER_v3_8", "internalAddress": "3.8", "type": "HAE_METER_v3_8", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v3_8", "CurrentHeatQuantity": "NaN", "CurrentHeatFlow": "NaN"}}'
  elseif toonVersion == "2v4" then -- Toon version 2v4
    apiResult = '{"dev_settings_device": {"uuid": "2d5bcbb7-dc35-4e2e-972a-77b77f73e42e", "name": "settings_device", "internalAddress": "settings_device", "type": "settings_device"}, "dev_4": {"uuid": "b36183a7-e406-4111-b164-33a72231de34", "name": "HAE_METER_v4", "internalAddress": "6", "type": "HAE_METER_v4", "supportsCrc": "1", "ccList": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "supportedCC": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "nodeFlags": [], "IsConnected": "1", "HealthValue": "-1", "DeviceName": "HAE_METER_v4", "CurrentSensorStatus": "UNKNOWN"}, "dev_4.1": {"uuid": "51c0e14b-4634-4055-b3cd-6d93a8c0e9b7", "name": "HAE_METER_v4_1", "internalAddress": "6.1", "type": "HAE_METER_v4_1", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "OPERATIONAL", "CurrentGasFlow": "407.00", "CurrentGasQuantity": "9790013.00", "DeviceName": "HAE_METER_v4_1"}, "dev_4.2": {"uuid": "f7fe281a-7c95-48b8-9984-ff6ff73c87a9", "name": "HAE_METER_v4_2", "internalAddress": "6.2", "type": "HAE_METER_v4_2", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_2", "CurrentElectricityFlow": "NaN", "CurrentElectricityQuantity": "NaN"}, "dev_4.3": {"uuid": "b66e2b0e-14b0-4a41-a814-809ce1690c91", "name": "HAE_METER_v4_3", "internalAddress": "6.3", "type": "HAE_METER_v4_3", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_3", "CurrentElectricityFlow": "NaN", "CurrentElectricityQuantity": "NaN"}, "dev_4.4": {"uuid": "a9297e52-4193-4d21-ba12-ba1562f38b38", "name": "HAE_METER_v4_4", "internalAddress": "6.4", "type": "HAE_METER_v4_4", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "OPERATIONAL", "DeviceName": "HAE_METER_v4_4", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "24557836.00"}, "dev_4.5": {"uuid": "8aff2655-4017-4d40-8d85-30c2f9be08d6", "name": "HAE_METER_v4_5", "internalAddress": "6.5", "type": "HAE_METER_v4_5", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_5", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "6358776.00"}, "dev_4.6": {"uuid": "f7ccfa90-19f3-4cd9-a400-de8e7f2f1b02", "name": "HAE_METER_v4_6", "internalAddress": "6.6", "type": "HAE_METER_v4_6", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_6", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "28417665.00"}, "dev_4.7": {"uuid": "25398f87-7244-4d1e-bca7-8b6889ec9fdb", "name": "HAE_METER_v4_7", "internalAddress": "6.7", "type": "HAE_METER_v4_7", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_7", "CurrentElectricityFlow": "800.00", "CurrentElectricityQuantity": "2555416.00"}, "dev_4.8": {"uuid": "6ec86c75-18e4-4ec9-a02c-d889b119642b", "name": "HAE_METER_v4_8", "internalAddress": "6.8", "type": "HAE_METER_v4_8", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_8", "CurrentHeatQuantity": "NaN", "CurrentHeatFlow": "NaN"}, "dev_4.9": {"uuid": "1661001c-635e-46ff-b943-55cf72de69e1", "name": "HAE_METER_v4_9", "internalAddress": "6.9", "type": "HAE_METER_v4_9", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_9", "CurrentWaterQuantity": "NaN", "CurrentWaterFlow": "NaN"}}'
  elseif toonVersion == "2v5" then -- Toon version 2v5
    apiResult = '{"dev_settings_device": {"uuid": "2d5bcbb7-dc35-4e2e-972a-77b77f73e42e", "name": "settings_device", "internalAddress": "settings_device", "type": "settings_device"}, "dev_5": {"uuid": "b36183a7-e406-4111-b164-33a72231de34", "name": "HAE_METER_v4", "internalAddress": "6", "type": "HAE_METER_v4", "supportsCrc": "1", "ccList": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "supportedCC": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "nodeFlags": [], "IsConnected": "1", "HealthValue": "-1", "DeviceName": "HAE_METER_v4", "CurrentSensorStatus": "UNKNOWN"}, "dev_5.1": {"uuid": "51c0e14b-4634-4055-b3cd-6d93a8c0e9b7", "name": "HAE_METER_v4_1", "internalAddress": "6.1", "type": "HAE_METER_v4_1", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "OPERATIONAL", "CurrentGasFlow": "407.00", "CurrentGasQuantity": "9790013.00", "DeviceName": "HAE_METER_v4_1"}, "dev_5.2": {"uuid": "f7fe281a-7c95-48b8-9984-ff6ff73c87a9", "name": "HAE_METER_v4_2", "internalAddress": "6.2", "type": "HAE_METER_v4_2", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_2", "CurrentElectricityFlow": "NaN", "CurrentElectricityQuantity": "NaN"}, "dev_5.3": {"uuid": "b66e2b0e-14b0-4a41-a814-809ce1690c91", "name": "HAE_METER_v4_3", "internalAddress": "6.3", "type": "HAE_METER_v4_3", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_3", "CurrentElectricityFlow": "NaN", "CurrentElectricityQuantity": "NaN"}, "dev_5.4": {"uuid": "a9297e52-4193-4d21-ba12-ba1562f38b38", "name": "HAE_METER_v4_4", "internalAddress": "6.4", "type": "HAE_METER_v4_4", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "OPERATIONAL", "DeviceName": "HAE_METER_v4_4", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "24557836.00"}, "dev_5.5": {"uuid": "8aff2655-4017-4d40-8d85-30c2f9be08d6", "name": "HAE_METER_v4_5", "internalAddress": "6.5", "type": "HAE_METER_v4_5", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_5", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "6358776.00"}, "dev_5.6": {"uuid": "f7ccfa90-19f3-4cd9-a400-de8e7f2f1b02", "name": "HAE_METER_v4_6", "internalAddress": "6.6", "type": "HAE_METER_v4_6", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_6", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "28417665.00"}, "dev_5.7": {"uuid": "25398f87-7244-4d1e-bca7-8b6889ec9fdb", "name": "HAE_METER_v4_7", "internalAddress": "6.7", "type": "HAE_METER_v4_7", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_7", "CurrentElectricityFlow": "800.00", "CurrentElectricityQuantity": "2555416.00"}, "dev_5.8": {"uuid": "6ec86c75-18e4-4ec9-a02c-d889b119642b", "name": "HAE_METER_v4_8", "internalAddress": "6.8", "type": "HAE_METER_v4_8", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_8", "CurrentHeatQuantity": "NaN", "CurrentHeatFlow": "NaN"}, "dev_5.9": {"uuid": "1661001c-635e-46ff-b943-55cf72de69e1", "name": "HAE_METER_v4_9", "internalAddress": "6.9", "type": "HAE_METER_v4_9", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_9", "CurrentWaterQuantity": "NaN", "CurrentWaterFlow": "NaN"}}'
  elseif toonVersion == "2v6" then -- Toon version 2v6
    apiResult = '{"dev_settings_device": {"uuid": "2d5bcbb7-dc35-4e2e-972a-77b77f73e42e", "name": "settings_device", "internalAddress": "settings_device", "type": "settings_device"}, "dev_6": {"uuid": "b36183a7-e406-4111-b164-33a72231de34", "name": "HAE_METER_v4", "internalAddress": "6", "type": "HAE_METER_v4", "supportsCrc": "1", "ccList": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "supportedCC": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "nodeFlags": [], "IsConnected": "1", "HealthValue": "-1", "DeviceName": "HAE_METER_v4", "CurrentSensorStatus": "UNKNOWN"}, "dev_6.1": {"uuid": "51c0e14b-4634-4055-b3cd-6d93a8c0e9b7", "name": "HAE_METER_v4_1", "internalAddress": "6.1", "type": "HAE_METER_v4_1", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "OPERATIONAL", "CurrentGasFlow": "407.00", "CurrentGasQuantity": "9790013.00", "DeviceName": "HAE_METER_v4_1"}, "dev_6.2": {"uuid": "f7fe281a-7c95-48b8-9984-ff6ff73c87a9", "name": "HAE_METER_v4_2", "internalAddress": "6.2", "type": "HAE_METER_v4_2", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_2", "CurrentElectricityFlow": "NaN", "CurrentElectricityQuantity": "NaN"}, "dev_6.3": {"uuid": "b66e2b0e-14b0-4a41-a814-809ce1690c91", "name": "HAE_METER_v4_3", "internalAddress": "6.3", "type": "HAE_METER_v4_3", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_3", "CurrentElectricityFlow": "NaN", "CurrentElectricityQuantity": "NaN"}, "dev_6.4": {"uuid": "a9297e52-4193-4d21-ba12-ba1562f38b38", "name": "HAE_METER_v4_4", "internalAddress": "6.4", "type": "HAE_METER_v4_4", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "OPERATIONAL", "DeviceName": "HAE_METER_v4_4", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "24557836.00"}, "dev_6.5": {"uuid": "8aff2655-4017-4d40-8d85-30c2f9be08d6", "name": "HAE_METER_v4_5", "internalAddress": "6.5", "type": "HAE_METER_v4_5", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_5", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "6358776.00"}, "dev_6.6": {"uuid": "f7ccfa90-19f3-4cd9-a400-de8e7f2f1b02", "name": "HAE_METER_v4_6", "internalAddress": "6.6", "type": "HAE_METER_v4_6", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_6", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "28417665.00"}, "dev_6.7": {"uuid": "25398f87-7244-4d1e-bca7-8b6889ec9fdb", "name": "HAE_METER_v4_7", "internalAddress": "6.7", "type": "HAE_METER_v4_7", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_7", "CurrentElectricityFlow": "800.00", "CurrentElectricityQuantity": "2555416.00"}, "dev_6.8": {"uuid": "6ec86c75-18e4-4ec9-a02c-d889b119642b", "name": "HAE_METER_v4_8", "internalAddress": "6.8", "type": "HAE_METER_v4_8", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_8", "CurrentHeatQuantity": "NaN", "CurrentHeatFlow": "NaN"}, "dev_6.9": {"uuid": "1661001c-635e-46ff-b943-55cf72de69e1", "name": "HAE_METER_v4_9", "internalAddress": "6.9", "type": "HAE_METER_v4_9", "supportsCrc": "0", "ccList": "5e 59 85 8e 3c 3d 3e", "supportedCC": "5e 59 85 8e 3c 3d 3e", "nodeFlags": [], "CurrentSensorStatus": "UNKNOWN", "DeviceName": "HAE_METER_v4_9", "CurrentWaterQuantity": "NaN", "CurrentWaterFlow": "NaN"}}'
  else -- Toon version 1
    apiResult = '{"dev_settings_device": {"uuid": "17f709f0-dbb1-4081-808b-2152cf7622b5", "name": "settings_device", "internalAddress": "settings_device", "type": "settings_device"}, "dev_3": {"uuid": "bf979010-40ff-429d-ade3-9e272f4976d0", "name": "cv boven", "internalAddress": "3", "type": "FGWP011", "supportsCrc": "0", "ccList": "72 86 70 85 8e 25 73 32 31 7a", "supportedCC": "72 86 70 85 8e 25 73 32 31 7a", "nodeFlags": [], "TargetStatus": "1", "CurrentElectricityFlow": "3.20", "CurrentElectricityQuantity": "477620.00", "IsConnected": "1", "HealthValue": "10", "DeviceName": "cv boven"}, "dev_4": {"uuid": "b14e07b2-0b6b-4e59-8f51-2956f805261b", "name": "FGWP011", "internalAddress": "4", "type": "FGWP011", "supportsCrc": "0", "ccList": "72 86 70 85 8e 25 73 32 31 7a", "supportedCC": "72 86 70 85 8e 25 73 32 31 7a", "nodeFlags": [], "TargetStatus": "1", "CurrentElectricityFlow": "0.70", "CurrentElectricityQuantity": "601520.00", "IsConnected": "1", "HealthValue": "-1", "DeviceName": "FGWP011"}, "dev_10": {"uuid": "060d70a3-7362-4dd9-8509-06ee97b82546", "name": "HAE_METER_v3", "internalAddress": "10", "type": "HAE_METER_v3", "supportsCrc": "1", "ccList": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "supportedCC": "5e 86 72 32 56 5a 59 85 73 7a 60 8e 22 70 8b 3c 3d 3e", "nodeFlags": [], "IsConnected": "1", "HealthValue": "-1", "DeviceName": "HAE_METER_v3", "CurrentSensorStatus": "UNKNOWN"}, "dev_10.1": {"uuid": "9c804ca1-9139-42de-b5fe-a1b7266ab8d9", "name": "HAE_METER_v3_1", "internalAddress": "10.1", "type": "gas", "supportsCrc": "0", "nodeFlags": [], "CurrentGasFlow": "581.00", "CurrentGasQuantity": "7277954.00", "DeviceName": "HAE_METER_v3_1"}, "dev_10.2": {"uuid": "ee17f68e-8786-4708-a622-2ac201448266", "name": "HAE_METER_v3_2", "internalAddress": "10.2", "type": "elec", "supportsCrc": "0", "nodeFlags": [], "CurrentElectricityFlow": "0", "CurrentElectricityQuantity": "0", "DeviceName": "HAE_METER_v3_2"}, "dev_10.3": {"uuid": "834b1da5-0a15-446f-8ae6-15cf255230e5", "name": "HAE_METER_v3_3", "internalAddress": "10.3", "type": "elec_solar", "supportsCrc": "0", "nodeFlags": [], "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "0.00", "DeviceName": "HAE_METER_v3_3"}, "dev_10.4": {"uuid": "0a16a44e-648e-4b1a-b0eb-752af278dd9a", "name": "HAE_METER_v3_4", "internalAddress": "10.4", "type": "elec_delivered_nt", "supportsCrc": "0", "nodeFlags": [], "CurrentElectricityFlow": "326.00", "CurrentElectricityQuantity": "10670267.00", "DeviceName": "HAE_METER_v3_4"}, "dev_10.5": {"uuid": "7bbb4598-3288-4a12-931c-f839c2aca8b9", "name": "HAE_METER_v3_5", "internalAddress": "10.5", "type": "elec_received_nt", "supportsCrc": "0", "nodeFlags": [], "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "4747586.00", "DeviceName": "HAE_METER_v3_5"}, "dev_10.6": {"uuid": "9c0a2fbd-526f-41ae-ade8-7ed7e0d42bce", "name": "HAE_METER_v3_6", "internalAddress": "10.6", "type": "elec_delivered_lt", "supportsCrc": "0", "nodeFlags": [], "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "11662485.00", "DeviceName": "HAE_METER_v3_6"}, "dev_10.7": {"uuid": "e87a8157-dfcf-4403-aab1-ced37e99b529", "name": "HAE_METER_v3_7", "internalAddress": "10.7", "type": "elec_received_lt", "supportsCrc": "0", "nodeFlags": [], "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "1839937.00", "DeviceName": "HAE_METER_v3_7"}, "dev_10.8": {"uuid": "c29b354f-0faf-4e29-8249-949d0d0aa3b6", "name": "HAE_METER_v3_8", "internalAddress": "10.8", "type": "heat", "supportsCrc": "0", "nodeFlags": [], "CurrentHeatQuantity": "0", "DeviceName": "HAE_METER_v3_8"}, "dev_15": {"uuid": "1095b3a3-c3c8-4a1b-b8f7-8247835c50fd", "name": "vaatwasser", "internalAddress": "15", "type": "FGWPF102", "supportsCrc": "1", "ccList": "5e 22 85 59 70 56 5a 7a 72 32 8e 71 73 98 31 25 86", "supportedCC": "5e 22 85 59 70 56 5a 7a 72 32 8e 71 73 98 31 25 86", "nodeFlags": [], "IsConnected": "1", "DeviceName": "vaatwasser", "TargetStatus": "1", "CurrentElectricityFlow": "0.00", "CurrentElectricityQuantity": "844600.00", "HealthValue": "-1"}}'
  end
  
  apiResult = apiResult:gsub("NaN", "0") -- clean up the response.data by replacing NaN with 0
  --self:logging(3,"Response data withoot null: " ..response.data)
  jsonTable = json.decode(apiResult) -- Decode the json string from api to lua-table 

  if toonVersion == "2v2" or toonVersion == "2" then -- Get the values for Toon version 2v2
    self:valuesToon2v2() 
  elseif toonVersion == "2v3" then -- Get the values for Toon version 2v3
    self:valuesToon2v3() 
  elseif toonVersion == "2v4" then -- Get the values for Toon version 2v4
    self:valuesToon2v4() 
  elseif toonVersion == "2v5" then -- Get the values for Toon version 2v5
    self:valuesToon2v5() 
  elseif toonVersion == "2v6" then -- Get the values for Toon version 2v6
    self:valuesToon2v6() 
  else -- Get values for Toon version 1
    self:valuesToonOne() 
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
  self:logging(3,"getData() - Get data from Toon")
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

      if toonVersion == "2v2" or toonVersion == "2" then -- Get the values for Toon version 2v2
        self:valuesToon2v2() 
      elseif toonVersion == "2v3" then -- Get the values for Toon version 2v3
        self:valuesToon2v3() 
      elseif toonVersion == "2v4" then -- Get the values for Toon version 2v4
        self:valuesToon2v4() 
      elseif toonVersion == "2v5" then -- Get the values for Toon version 2v5
        self:valuesToon2v5() 
      elseif toonVersion == "2v6" then -- Get the values for Toon version 2v6
        self:valuesToon2v6() 
      else -- Get values for Toon version 1
        self:valuesToonOne() 
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
  self:logging(3,"createVariables() - Create all Variables")
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
  translation = i18n:translation(string.lower(self:getVariable("language"))) -- Initialise the translation
end


function QuickApp:getQuickappVariables() -- Get all Quickapp Variables or create them
  IPaddress = self:getVariable("IPaddress")
  toonVersion = self:getVariable("toonVersion")
  local language = string.lower(self:getVariable("language"))
  Interval = tonumber(self:getVariable("Interval")) 
  debugLevel = tonumber(self:getVariable("debugLevel"))

  -- Check existence of the mandatory variables, if not, create them with default values 
  if IPaddress == "" or IPaddress == nil then 
    IPaddress = "192.168.1.50" -- Default IPaddress 
    self:setVariable("IPaddress", IPaddress)
    self:trace("Added QuickApp variable IPaddress")
  end
  if toonVersion == "" or toonVersion == nil then 
    toonVersion = "2v6" -- Default Toon Version (latest version 2v6)
    self:setVariable("toonVersion", toonVersion)
    self:trace("Added QuickApp variable toonVersion")
  end
  if language == "" or language == nil or type(i18n:translation(string.lower(self:getVariable("language")))) ~= "table" then
    language = "en" 
    self:setVariable("language",language)
    self:trace("Added QuickApp variable language")
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
      {className="consumption", name="Consumption", type="com.fibaro.powerMeter", value=0}, 
      {className="production", name="Production", type="com.fibaro.powerMeter", value=0},
      {className="consumption_high", name="Consumption High", type="com.fibaro.energyMeter", value=0},
      {className="consumption_low", name="Consumption Low", type="com.fibaro.energyMeter", value=0},
      {className="production_high", name="Production High", type="com.fibaro.energyMeter", value=0},
      {className="production_low", name="Production Low", type="com.fibaro.energyMeter", value=0},
      {className="production_act", name="Production Actual", type="com.fibaro.powerMeter", value=0}, 
      {className="gas", name="Gas", type="com.fibaro.gasMeter", value=0},
      {className="total_gas", name="Gas Total", type="com.fibaro.gasMeter", value=0},
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