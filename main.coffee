express = require('express')
app = express()
bodyParser = require('body-parser')
session = require('express-session')
uuid = require('uuid')
glob = require('glob')



module.exports = ->
  
  glob("#{__dirname}/modules{_server,_client}/!(_**)/endpoints.*",(err, files)->
    app.use(session(
      genid: (req) ->
        uuid.v4()
      secret: '1234567890QWERTY'
      saveUninitialized: true
      resave: true
      cookie:
        maxAge: (1000 * 60 * 60)
    ))
    
    app.enable('trust proxy')
    
    app.use(bodyParser.urlencoded({ extended: false }))
    app.use(bodyParser.json())
    
  
    for file in files
      rtr = require(file)
      if !Array.isArray(rtr.router)
          app.use(rtr.scope, rtr.router);
        else
          for subRouter in rtr.router
            app.use(rtr.scope, subRouter)
    
    app.use((req, res, next)->
      res.redirect(301, '/404') if req.originalUrl isnt '/404'      
    )
    
    console.log('App started')
    app.listen(8000)
  )