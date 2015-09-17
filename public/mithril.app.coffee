isNode = typeof window is 'undefined' and typeof module isnt 'undefined'


do ->
  "use strict"

  if typeof m is 'undefined'
    console.error('Global m variable not defined')
    return false


  isModule = (ob) ->
    ob.controller isnt undefined and ob.view isnt undefined



  routePaths = []



  formatAjaxRequest = (ob) ->
    ob.method = 'GET' if !ob.method
    ob.method = ob.method.toUpperCase()
    ob.complete = (->) if typeof ob.complete isnt 'function'
    ob.background = true

    if ['HEAD', 'GET'].indexOf(ob.method) > -1 and typeof ob.data is 'object' and Object.keys(ob.data).length
      qs = []
      for own key, val of ob.data
        qs.push(encodeURIComponent(key) + "=" + encodeURIComponent(val))

      ob.url += if ob.url.indexOf("?") > -1 then "&" else "?"
      ob.url += qs.join("&")
      ob.data = {}

    ob



  escapeRegExp = (s)  ->
      s.replace(/[-/\\^$*+?.()|[\]{}]/g, '\\$&')



  bindElEvents = (el, events) ->
    for own key, evt of events
      el.addEventListener(key, evt)



  unbindElEvents = (el, events) ->
    for own key, evt of events
      el.removeEventListener(key, evt)
      delete events[key]



  headersToJson = (str) ->
    ob = {}

    for line in str.split("\n")
      ob[line.substring(0, line.indexOf(":")).trim()] = line.substring(line.indexOf(":")+1).trim()

    JSON.stringify(ob)



  shiftWalker = (arr, final, seed, req, res)->
    if not arr or not arr.length
      final(seed)
      return

    item = arr.shift()

    shiftWalker(arr, final, seed, req, res) if not item

    if typeof item is 'string' or typeof item is 'number'
      shiftWalker(arr, final, seed + item, req, res)
    else if typeof item is 'object' and item['$trusted'] isnt undefined
      for own k, v of item
        seed += v if not /[\D]/.test(k)
      shiftWalker(arr, final, seed, req, res)
    else if typeof item is 'object'
      m.toString(item, (newHtml)->
        shiftWalker(arr, final, seed + newHtml, req, res)
      , req, res)



  oRoute = m.route
  oRouteProps = {}
  for own k,v of m.route
    oRouteProps[k] = v



  Object.defineProperties(m,
    'query':
      enumerable: true
      configurable: false
      writable: false
      value: (selectorOrElement, selector) ->
        return null if isNode

        if selector is undefined
          q = document.querySelectorAll.apply(document, [selectorOrElement])
        else
          q = selectorOrElement.querySelectorAll.apply(selectorOrElement, [selector])
        return if q.length is 1 then q[0] else q



    'matches':
      enumerable: true
      configurable: false
      writable: false
      value: (el, selector) ->
        method = el.matches or el.msMatchesSelector or el.mozMatchesSelector or el.webkitMatchesSelector or el.oMatchesSelector or false
        if method then method.apply(el, [selector]) else false



    'toRegister':
      enumerable: false
      configurable: false
      writable: false
      value: []



    'readyQueue':
      enumerable: false
      configurable: false
      writable: false
      value: []



    'ready':
      enumerable: true
      configurable: false
      writable: false
      value: (cb) ->
        if isNode or document.readyState is "complete"
          cb()
        else
          if !m.readyQueue.length
            window.onload = ()->
              while m.readyQueue.length
                (m.readyQueue.shift())()

          m.readyQueue.push(cb)



    'register':
      enumerable: true
      configurable: false
      writable: false
      value: (module) ->
        module.controller = (->) if module.controller is undefined
        module.view = (-> return null) if module.view is undefined
        module.route = null if module.route is undefined or !module.route.length
        module.route = [module.route] if module.route and not Array.isArray(module.route)
        
        m.toRegister.push(module) if m.toRegister.indexOf(module) is -1



    'route':
      enumerable: true
      configurable: false
      writable: true
      value: (first) ->
        if typeof first is 'string'
          if ! routePaths.some((i)-> i.test(first) )
            console.error("No route #{first} defined")
            return
          
        oRoute.apply(@, arguments)
        oRoute



    'start':
      enumerable: true
      configurable: false
      writable: false
      value: (DOMRoot) ->
        return m.toRegister if isNode
        
        for own k,v of oRouteProps
          m.route[k] = v
        
        m.route.mode = "pathname"
        
        routeHash = {}
        
        while m.toRegister.length
          currMod = m.toRegister.shift()

          if currMod.route
            for subroute in currMod.route
              routeHash[subroute] = currMod

        if routeHash['/'] is undefined
          return console.warn("No root \"/\" route defined")

        m.route(DOMRoot, '/', routeHash) if Object.keys(routeHash).length
        
        routePaths = Object.keys(routeHash).map((i)->
          i = i.replace(/\/:[^\/]+/gi, '/[^\/]+?')            
          new RegExp("^" + i + "$")
        )



    'part':
      enumerable: true
      configurable: false
      writable: false
      value: (module, args, extra) ->
        module.view.bind(this, new module.controller(args, extra), args, extra)



    'refresh':
      enumerable: true
      configurable: false
      writable: false
      value: (module, args, extra) ->
        m.route(m.route())



    'el':
      enumerable: true
      configurable: false
      writable: false
      value: (str, hashOrChildren, children) ->
        hasEvents = false

        if children isnt undefined
          for own kk, vv of hashOrChildren when /^on[A-Za-z]/.test(kk) and typeof vv is 'function'
            hasEvents = {} if typeof hasEvents is 'boolean'
            hasEvents[kk.substring(2).toLowerCase()] = ((f)->
              () ->
                m.startComputation()
                f.apply(this, arguments)
                m.endComputation()
            )(vv)
            delete hashOrChildren[kk] 

          if hasEvents
            o_config = hashOrChildren.config or (->)

            hashOrChildren.config = (element, isInitialized, context) ->
              o_config.apply(this, [element, isInitialized, context])

              if !isInitialized
                context.eventMap = hasEvents
                bindElEvents(element, context.eventMap)

              o_unload = context.onunload or (->)
              context.onunload = () ->
                o_unload()                
                unbindElEvents(element, context.eventMap)


        m(str, hashOrChildren, children)



    'ajax':
      enumerable: true
      configurable: false
      writable: false
      value: (conf) ->
        return if isNode
        requestOptions = formatAjaxRequest(conf)
        transport = null

        requestOptions.extract = (xhr, xhrOptions) ->
          if xhr.status is 0
            return if xhr.statusText.length then xhr.statusText else JSON.stringify(
              message: 'aborted'
            )

          if xhr.status is 404
            return JSON.stringify(
              message: xhr.responseText or xhr.statusText
            )

          if xhrOptions.method is 'HEAD' then headersToJson(xhr.getAllResponseHeaders()) else xhr.responseText

        requestOptions.config = (xhr)->
          transport = xhr

          if conf.headers
            for own kk, vv of conf.headers
              xhr.setRequestHeader(kk, vv)
          xhr


        m.request(requestOptions)
          .then(
            (response) ->
              m.startComputation()
              conf.complete(null, response, transport)
              m.endComputation()
            ,
            (response) ->
              m.startComputation()
              conf.complete(response, null, transport)
              m.endComputation()
          )

        transport



    'extend':
      enumerable: true
      configurable: false
      writable: false
      value: (extend, using...) ->
        if typeof extend isnt 'object'
          console.error("Trying to extend", extend, "when it's not an object")
          return
        
        for feed in using
          if typeof feed isnt 'object'
            console.error("Trying to extend", feed, "when it's not an object")
            return
          
          for own kk, vv of feed
            if typeof vv is 'object' and not Array.isArray(vv) and typeof extend[kk] is 'object' and not Array.isArray(extend[kk])
              extend[kk] = m.extend(extend[kk], vv)
            else
              extend[kk] = vv

        extend




    'multiClass':
      enumerable: true
      configurable: false
      writable: false
      value: (classes...) ->
        classes.reduce (Parent, Child)->
          class Child_Projection extends Parent
            constructor: ->
              # Temporary replace Child.__super__ and call original `constructor`
              child_super = Child.__super__
              Child.__super__ = Child_Projection.__super__
              Child.apply(@, arguments)
              Child.__super__ = child_super

              # If Child.__super__ not exists, manually call parent `constructor`
              unless child_super?
                super()

          # Mixin prototype properties, except `constructor`
          for own key  of Child::
            if Child::[key] isnt Child
              Child_Projection::[key] = Child::[key]

          # Mixin static properties, except `__super__`
          for own key  of Child
            if Child[key] isnt Object.getPrototypeOf(Child::)
              Child_Projection[key] = Child[key]

          Child_Projection



    'toString':
      enumerable: true
      configurable: false
      writable: false
      value: (stack=null, cb=(->), req = null, res = null) ->
        cb('') if not stack

        if isNode and isModule(stack)

          # Mithril module with server-side controller
          new stack.controller(req, res, (ctrl)->
            m.toString(stack.view(ctrl),(newHtml)->
              cb(newHtml, ctrl)
            )
          )

        else

          html = ''

          if Array.isArray(stack)

            # Array of plain Mithril objects
            shiftWalker(stack, cb, html, req, res)

          else if stack.controller is undefined and stack.view is undefined

            # Plain Mithril objects
            html += "<#{stack.tag}" if stack.tag

            if stack.attrs and Object.keys(stack.attrs).length
              attrs = []
              for own attr, val of stack.attrs when !/^on[A-Za-z]/.test(attr) and typeof val isnt 'function'
                val = val.replace(/"/gim, '\\"')
                attrs.push("#{attr}=\"#{val}\"")

              html += " " + attrs.join(" ") if attrs.length

            html += ">" if stack.tag

            shiftWalker(stack.children, (newHtml)->
              newHtml += "</#{stack.tag}>" if stack.tag
              cb(newHtml)
            , html, req, res)

          else

            # Mithril module with client-side controllerc
            ctrl = new stack.controller()
            m.toString(stack.view(ctrl), (newHtml)->
              html += newHtml
              cb(html, ctrl)
            , req, res)
  )

  if isNode
    m.route = (-> undefined)
    m.route.param = (-> undefined)
    m.request = (->)
    module.exports = m