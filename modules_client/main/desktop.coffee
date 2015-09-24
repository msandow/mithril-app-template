require('./../../public/mithril.app.coffee')

m.ready(->
  for module in [
    require('./../404/desktop.coffee')
    require('./../index/desktop.coffee')
    require('./../user/desktop.coffee')
  ]
    if Array.isArray(module)
      m.register(subModule) for subModule in module      
    else
      m.register(module)

  m.start(m.query('body'))
)