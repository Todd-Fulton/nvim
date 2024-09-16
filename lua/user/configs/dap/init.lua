local modpath = (...):gsub(".init", "")
return {
  adapters = require(modpath .. ".adapters"),
  configurations = require(modpath .. ".configurations"),
}
