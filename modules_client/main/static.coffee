require('./../../public/mithril.app.coffee')

module.exports = ->
  for module in [
    require('./../index/static.coffee')
    require('./../login/static.coffee')
  ]
    m.register(module)

  m.start(m.query('body'))