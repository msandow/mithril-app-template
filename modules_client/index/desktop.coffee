authController = require('./../_utilities/authenticatedController.coffee')

module.exports = 
    
  controller: class extends authController
    constructor: ->
      super(=>
        document.addEventListener('click', @documentEvent)
      )
    
    onunload: ->
      document.removeEventListener('click', @documentEvent)
    
    documentEvent: (evt)->
      console.log(evt.target)

  view: (ctx)->
    return m.el('span','loading...') if not ctx.viewReady
    
    m.el('h1','Hello world')

  route: '/'