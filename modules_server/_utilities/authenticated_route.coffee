express = require('express')
sessMgmt = require('./session_management.coffee')

module.exports = () ->
  Router = new express.Router()

  Router.use((req, res, next)->
    sess = sessMgmt(req, res)
    
    if sess.validate()
      next()
    else
      res.status(401).json({message: 'Not logged in'}).end()
  )
  
  Router
