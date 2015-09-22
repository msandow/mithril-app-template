desktop = require('./desktop.coffee')

module.exports = m.extend(desktop,
  controller:  class
    constructor: (req, res, triggerView) ->
      @headerMessage = switch req.params?.message
        when 'timeout' then 'You\'ve timed out'
        when undefined, false then 'Welcome'
      triggerView(@)
)