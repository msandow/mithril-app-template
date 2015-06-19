module.exports = 
  serverController: class
    constructor: (req, res, triggerView)->
      triggerView(@)
    
  controller: class
    constructor: ->
      true

  view: ->
    m.el('h1','Hello world')

  route: '/'