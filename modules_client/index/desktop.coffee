global = require('./../_global/desktopController.coffee')
auth = require('./../_global/authenticatedController.coffee')
internalLink = require('./../_cogs/links/desktop.coffee')
authAjax = require('./../_utilities/authenticatedAjax.coffee')
invalidate = require('./../_utilities/utils.coffee').invalidateUser

module.exports = 
    
  controller: class extends m.multiClass(global, auth)
    constructor: ->
      super(=>
        @globalSetup()
        document.addEventListener('click', @documentEvent)
      )
    
    onunload: ->
      document.removeEventListener('click', @documentEvent)
    
    documentEvent: (evt)->
      console.log(evt.target)

  view: (ctx)->
    return m.el('span','loading...') if not ctx.viewReady
    
    [
      m.el('h1','Hello world')
      m.el('p', internalLink('Same page', '/'))
      m.el('p', m.el('a', {
        href: ''
        onclick: (evt)->
          evt.preventDefault()
          
          authAjax(
            url: '/endpoint/user/logout/'
            method: 'POST'
            complete: ->
              invalidate()
          )
          
      }, 'Log out'))
    ]

  route: '/'