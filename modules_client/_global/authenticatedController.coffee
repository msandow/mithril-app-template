authAjax = require('./../_utilities/authenticatedAjax.coffee')

module.exports = class
  authenticate: (cb)->
    @viewReady = false
    
    authAjax(
      method: 'GET'
      url: '/endpoint/user/check/'
      complete: (error, response)=>
        @viewReady = true
        cb.call(@)
    )