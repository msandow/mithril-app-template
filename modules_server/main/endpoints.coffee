express = require('express')
Boxy = require('BoxyBrown')


sharedFolder = "#{__dirname}/../_utilities"
publicFolder = "#{__dirname}/../../public"
clientFolder = "#{__dirname}/../../modules_client"

global.m = require("#{publicFolder}/mithril.js")
staticApp = require("#{clientFolder}/main/static.coffee")

Router = require("#{sharedFolder}/open_route.coffee")()

Router.use(Boxy.CoffeeJs(
  route: '/js/desktop.js'
  source: "#{clientFolder}/main/desktop.coffee"
  debug: true
))


Router.use(Boxy.ScssCss(
  route: '/css/desktop.css'
  source: "#{clientFolder}/main/desktop.scss"
  debug: true
))



buildStaticRoute = (route, module) ->
  Router.get(route, (req, res)->
    m.toString(module, (html, ctrl)->
      Boxy.TokenReplacer("#{__dirname}/../../public/index.html", {
        compiledHtml: html
        keywords: ''
        description: ''
      }, (err, data)->
        res.end(err or data)
      )
    , req, res)
  )

for staticModule in staticApp()
  for subRoute in staticModule.route
    buildStaticRoute(subRoute, staticModule)



Router.use(express.static(publicFolder))



module.exports = 
  scope: '/'
  router: Router