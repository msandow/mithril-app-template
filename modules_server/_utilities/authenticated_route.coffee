express = require('express')
getUTCTime = require('./utils.coffee').getUTCTime

module.exports = () ->
  Router = new express.Router()

  Router.use((req, res, next)->
    if !!(req.session?.userId &&
      req.session?.CSRF &&
      req.headers['x-csrf-token'] &&
      req.session.CSRF is req.headers['x-csrf-token'] &&
      req.session?.expires &&
      req.session.expires - getUTCTime() > 0
    )
        next()
    else
      req.session.destroy() if req.session?.userId
      res.status(401).json({message: 'Not logged in'}).end()
  )
  
  Router
