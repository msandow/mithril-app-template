desktop = require('./desktop.coffee')
  
module.exports = m.extend(desktop,
  controller: class
    constructor: (req, res, triggerView) ->
      triggerView(@)
)