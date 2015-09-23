uuid = require('uuid')
utils = require('./utils.coffee')

SESSION_MINUTES = 0.5

module.exports = (req, res) ->
  
  CSRF = (val) ->
    if val isnt undefined
      req.session.CSRF = val
      return val
    
    req.session and
      req.session.CSRF and
      req.headers['x-csrf-token'] and
      req.session.CSRF is req.headers['x-csrf-token']


  expiration = (val) ->
    if val isnt undefined
      req.session.expires = val
      return val
    
    req.session and
      req.session.expires and
      req.session.expires - utils.getUTCTime() > 0


  userAgent = (val) ->
    if val isnt undefined
      req.session.userAgent = val
      return val
    
    req.session and
      req.session.userAgent and
      req.session.userAgent is (req.headers['user-agent'] or "")


  IP = (val) ->
    if val isnt undefined
      req.session.IP = val
      return val
    
    req.session and
      req.session.IP and
      req.session.IP is utils.getReqIP(req)



  {
    validate: ->      
      !!(req.session?.userId and CSRF() and expiration() and userAgent() and IP())
    
    set: (userId)->
      req.session.userId = userId
      
      CSRF(uuid.v4()) if !req.session.CSRF
      expiration(utils.getUTCTime() + (1000 * 60 * SESSION_MINUTES))
      userAgent(req.headers['user-agent'] or "")
      IP(utils.getReqIP(req))
    
    destroy: (cb)->
      req.session.destroy(->
        cb()
      )
    
    reload: (cb)->
      req.session.reload(->
        cb()
      )
  }