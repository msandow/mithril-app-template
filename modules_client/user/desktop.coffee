forms = require('./../_cogs/forms/desktop.coffee')

module.exports =
  
  controller: class
    constructor: ->
      @headerMessage = switch m.route.param("message")
        when 'timeout' then 'You\'ve timed out'
        when undefined, false then 'Welcome'

      @un = m.prop("")
      @pw = m.prop("")


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
      forms.text(ctx.un, {placeholder: 'Username'}),
      m('br'),
      forms.password(ctx.pw, {placeholder: 'Password'}),
      m('br'),
      m.el('button','Login')
    ])


  route: ['/user', '/user/:message']