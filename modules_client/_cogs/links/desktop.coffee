module.exports = (text, href)->
  m.el('a',{config: m.route, href: href}, text)