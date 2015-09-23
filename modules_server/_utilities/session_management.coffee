uuid = require('uuid')
utils = require('./utils.coffee')

SESSION_MINUTES = 0.5

module.exports = (req, res) ->

  map = {}
  
  Object.defineProperties(map,
    CSRF:
      get: () ->
        valid = req.session and
          req.session.CSRF and
          req.headers['x-csrf-token'] and
          req.session.CSRF is req.headers['x-csrf-token']
        
        if !valid
          console.log("Incorrect CSRF token - Session: #{req.session.CSRF} Request: #{req.headers['x-csrf-token']}")
        
        valid
      set: (val) ->
        req.session.CSRF = val
    
    expiration:
      get: () ->
        valid = req.session and
          req.session.expires and
          req.session.expires - utils.getUTCTime() > 0
        
        if !valid
          console.log("Session expiration passed - #{req.session.expires - utils.getUTCTime()}")
        
        valid
      set: (val) ->
        req.session.expires = val
    
    userAgent:
      get: () ->
        valid = 
          req.session and
          req.session.userAgent and
          req.session.userAgent is (req.headers['user-agent'] or "")
        
        if !valid
          console.log("Incorrect user agent - Session: #{req.session.userAgent} Request: #{req.headers['user-agent']}")
        
        valid
      set: (val) ->
        req.session.userAgent = val
    
    IP:
      get: () ->
        valid = req.session and
          req.session.IP and
          req.session.IP is utils.getReqIP(req)
        
        if !valid
          console.log("Incorrect IP - Session: #{req.session.IP} Request: #{utils.getReqIP(req)}")
        
        valid
      set: (val) ->
        req.session.IP = val
  )



  {
    validate: ->
      if !req.session?.userId
        console.log("No current session")
      
      !!(req.session?.userId and map.CSRF and map.expiration and map.userAgent and map.IP)
    
    set: (userId)->
      req.session.userId = userId
      
      map.CSRF = uuid.v4() if !req.session.CSRF
      map.expiration = utils.getUTCTime() + (1000 * 60 * SESSION_MINUTES)
      map.userAgent = req.headers['user-agent'] or ""
      map.IP = utils.getReqIP(req)
    
    destroy: (cb)->
      req.session.destroy(->
        cb()
      )
    
    reload: (cb)->
      req.session.reload(->
        cb()
      )
  }