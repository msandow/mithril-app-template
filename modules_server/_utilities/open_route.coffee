express = require('express')


module.exports = () ->
  Router = new express.Router()

  Router.use((req, res, next)->
    next()
  )
  
  Router
