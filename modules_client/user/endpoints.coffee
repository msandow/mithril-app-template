express = require('express')

serverShared = "#{__dirname}/../../modules_server/_utilities"

sessMgmt = require("#{serverShared}/session_management.coffee")

OpenRouter = require("#{serverShared}/open_route.coffee")()
SecureRouter = require("#{serverShared}/authenticated_route.coffee")()


OpenRouter.post('/login', (req, res)->
  if req.body.un is '1' and req.body.pw is '2'
    sess = sessMgmt(req, res)
    
    sess.reload(->
      sess.set(1234)
      
      res.json(
        userId: 1234
        csrf: req.session.CSRF
      )
    )
  else
    res.json({message: 'Invalid'})
)

SecureRouter.post('/logout', (req, res)->
  sess = sessMgmt(req, res)
  sess.destroy(->
    res.json({})
  )
)

SecureRouter.get('/check', (req, res)->
  res.json({})
)

module.exports = 
  scope: '/endpoint/user'
  router: [OpenRouter, SecureRouter]