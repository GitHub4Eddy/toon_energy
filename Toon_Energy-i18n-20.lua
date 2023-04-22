-- Toon Energy i18n Translations

class "i18n"
function i18n:translation(language)
  translation = {
    en = {
      ["SIMULATION MODE"] = "SIMULATION MODE", 
      ["Consumption"] = "Consumption", 
      ["Production"] = "Production", 
      ["Consumption High"] = "Consumption High", 
      ["Consumption Low"] = "Consumption Low", 
      ["Production High"] = "Production High", 
      ["Production Low"] = "Production Low", 
      ["Consumption Total"] = "Consumption Total", 
      ["Production Total"] = "Production Total", 
      ["Production Actual"] = "Production Actual", 
      ["Gas Usage"] = "Gas Usage", 
      ["Gas Total"] = "Gas Total", 
      ["Last Run"] = "Last Run"}, 
    nl = {
      ["SIMULATION MODE"] = "SIMULATIE MODE", 
      ["Consumption"] = "Consumptie", 
      ["Production"] = "Productie", 
      ["Consumption High"] = "Consumptie hoog", 
      ["Consumption Low"] = "Consumptie laag", 
      ["Production High"] = "Consumptie hoog", 
      ["Production Low"] = "Consumptie laag", 
      ["Consumption Total"] = "Consumptie totaal", 
      ["Production Total"] = "Consumptie totaal", 
      ["Production Actual"] = "Consumptie werkelijk", 
      ["Gas Usage"] = "Gas verbruik", 
      ["Gas Total"] = "Gas totaal", 
      ["Last Run"] = "Laatste ronde"},} 
    translation = translation[language] -- Shorten the table to only the current translation
  return translation
end

-- EOF