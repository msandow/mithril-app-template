textInput = (binding, conf={}, tag = 'input') ->
  conf.oninput = (evt)->
    binding(evt.target.value)
  
  conf.config = (element, isInitialized, context) ->
    if !isInitialized
      element.value = binding()
  
  m.el(tag,conf)

clickInput = (binding, conf={}) ->
  conf.onchange = (evt)->
    if evt.target.getAttribute('name') and conf.type is 'checkbox'
      names = Array.prototype.slice.call(
        document.getElementsByName(evt.target.getAttribute('name'))
      ).filter((e)->
        e.checked
      ).map((e)->
        e.value
      )
      
      if names.length
        binding(names.join(','))
      else
        binding('')
    else
      if evt.target.checked
        binding(evt.target.value)
      else
        binding('')
  
  conf.config = (element, isInitialized, context) ->
    if !isInitialized and conf.value is binding()
      element.checked = true
  
  m.el('input',conf)

module.exports = 
  text: (binding = (->), conf={}) ->
    conf.type = 'text'
    textInput(binding, conf)

  password: (binding = (->), conf={}) ->
    conf.type = 'password'
    textInput(binding, conf)
  
  checkbox: (binding = (->), val= '', conf={}) ->
    conf.type = 'checkbox'
    conf.value = val
    clickInput(binding, conf)
  
  radio: (binding = (->), val= '', conf={}) ->
    conf.type = 'radio'
    conf.value = val
    clickInput(binding, conf)