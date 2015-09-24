require('./../../public/mithril.app.coffee')

module.exports = ->
  for module in [
    require('./../404/static.coffee')
    require('./../index/static.coffee')
    require('./../user/static.coffee')
  ]
    if Array.isArray(module)
      m.register(subModule) for subModule in module      
    else
      m.register(module)

  m.start(m.query('body'))