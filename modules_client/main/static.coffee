require('./../../public/mithril.app.coffee')

module.exports = ->
  for module in [
    require('./../404/static.coffee')
    require('./../index/static.coffee')
    require('./../user/static.coffee')
  ]
    m.register(module)

  m.start(m.query('body'))