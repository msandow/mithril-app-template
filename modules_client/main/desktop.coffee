require('./../../public/mithril.app.coffee')

m.ready(->
  for module in [
    require('./../404/desktop.coffee')
    require('./../index/desktop.coffee')
    require('./../login/desktop.coffee')
  ]
    m.register(module)

  m.start(m.query('body'))
)