authAjax = require('./authenticatedAjax.coffee')

module.exports = class
  constructor: (cb)->
    @viewReady = false
    
    authAjax(
      method: 'GET'
      url: '/endpoint/login/check/'
      complete: (error, response)=>
        @viewReady = true
        cb.call(@)
    )