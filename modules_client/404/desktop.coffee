module.exports =
  
  controller: class
    constructor: ->
      true

  view: (ctx) ->
    m.el('h1','404 Not Found')


  route: ['/404']