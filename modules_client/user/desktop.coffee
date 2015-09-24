forms = require('./../_cogs/forms/desktop.coffee')
global = require('./../_global/desktopController.coffee')

module.exports =
  
  controller: class extends global
    constructor: ->
      @globalSetup()
      
      @headerMessage = switch m.route.param("message")
        when 'timeout' then 'You\'ve timed out'
        when undefined, false then 'Welcome'

      @un = m.prop("")
      @pw = m.prop("")
      @disabled = m.prop('1')


    loginSubmit: (evt)->
      evt.preventDefault()

      if not @un() or not @pw()
        alert('Please fill out the form')
      else
        m.ajax(
          method: 'POST'
          url: '/endpoint/user/login'
          data:
            un: @un()
            pw: @pw()
          complete: (error, response) =>
            if error or not response.userId
              alert('Please try again')
              return

            window.localStorage.setItem('currentUser', response.userId)
            window.localStorage.setItem('csrf', response.csrf)

            m.route('/')
        )

      false

  view: (ctx) ->
    m.el('form',{
      onsubmit: ctx.loginSubmit?.bind(ctx)
    },[
      m.el('h4',ctx.headerMessage)
      forms.text(ctx.un, {placeholder: 'Username', disabled: ctx.disabled() isnt '0'}),
      m('br'),
      forms.password(ctx.pw, {placeholder: 'Password', disabled: ctx.disabled() isnt '0'}),
      m('br'),
      m.el('button', {disabled: ctx.disabled() isnt '0'}, 'Login'),
      m.trust('<p>&nbsp;</p>'),
      m.if(
        ctx.disabled() isnt '0',
        m('span', {style:{'font-weight':700}},'Please click this box')
      )
      forms.checkbox(ctx.disabled, '0', {name:'foo'})
    ])


  route: ['/user', '/user/:message']