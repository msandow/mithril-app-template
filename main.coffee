express = require('express')
app = express()
bodyParser = require('body-parser')
session = require('express-session')
uuid = require('uuid')
glob = require('glob')



module.exports = ->

  app.use(session(
    genid: (req) ->
      uuid.v4()
    cookie:
      maxAge: 2419200000
    secret: '1234567890QWERTY'
    saveUninitialized: true
    resave: true
  ))

  app.use(bodyParser.urlencoded({ extended: false }))
  app.use(bodyParser.json())
  
  glob("#{__dirname}/modules{_server,_client}/!(_**)/endpoints.*",(err, files)->
    for file in files
      rtr = require(file)
      if !Array.isArray(rtr.router)
          app.use(rtr.scope, rtr.router);
        else
          for subRouter in rtr.router
            app.use(rtr.scope, subRouter)

    console.log('App started')
    app.listen(8000)
  )