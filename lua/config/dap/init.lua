local modpath = (...)
return {
  adapters = require(modpath .. ".adapters"),
  configurations = require(modpath .. ".configurations"),
}
