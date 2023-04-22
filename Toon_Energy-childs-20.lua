-- Toon Energy Childs

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
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Production High child device (" ..self.id ..") to production")
  end
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
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Production High child device (" ..self.id ..") to production")
  end
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

-- EOF