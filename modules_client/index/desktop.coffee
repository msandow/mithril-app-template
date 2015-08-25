module.exports = 
  serverController: class
    constructor: (req, res, triggerView)->
      triggerView(@)
    
  controller: class
    constructor: ->
      document.addEventListener('click', @documentEvent)
      true
    
    onunload: ->
      document.removeEventListener('click', @documentEvent)
    
    documentEvent: (evt)->
      console.log(evt.target)

  view: ->    
    m.el('h1','Hello world')

  route: '/'