invalidate = require('./utils.coffee').invalidateUser

module.exports = (configs) ->
  origCb = configs.complete or (->)
  
  configs = m.extend(configs,
    headers:
      csrf: window?.sessionStorage?.getItem('csrf') or ''
    complete: (error, response, xhr) ->
      if error and xhr?.status is 401
        if window.sessionStorage.currentUser?        
          invalidate('/login/timeout')
        else
          invalidate('/login')
        return 

      origCb.apply(this, arguments)
  )
  
  m.ajax(configs)