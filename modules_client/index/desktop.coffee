links = require('../_components/links/desktop.coffee')

module.exports = 
  serverController: class
    constructor: (req, res, triggerView)->
      triggerView(@)
    
  controller: class
    constructor: ->
      true

  view: ->
    me.el('h1','Hello world')

  route: '/'