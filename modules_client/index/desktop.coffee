secureAjax = require('./../_utilities/secureAjax.coffee')

module.exports = 
    
  controller: class
    constructor: ->
      document.addEventListener('click', @documentEvent)
      
      @viewReady = false
      
      secureAjax(
        method: 'GET'
        url: '/endpoint/login/check/'
        complete: (error, response)=>
          @viewReady = true
      )

    
    onunload: ->
      document.removeEventListener('click', @documentEvent)
    
    documentEvent: (evt)->
      console.log(evt.target)

  view: (ctx)->
    return m.el('span','loading...') if not ctx.viewReady
    
    m.el('h1','Hello world')

  route: '/'