Quick Mithril App
=================

### Purpose

By using this repo, you quickly get access to an app server that's based of the [Mithril MVC](http://lhorie.github.io/mithril/mithril.html), with a custom extension file that makes configuring a Mithril app a little more consistent. This combination not only makes for an extremely performant client-side app, but also uses the client-side views to create static server-side views too, so that all routes are crawler accesible and SEO friendly without having to set up a bunch of separate routes.

Please refer to the [Mithril App Extension](#extension) section to see more info about what the extension provides.

---

### Creating An App

Once you've cloned this repo, you can simply run the custom `clone` npm command to clone it to directory of your choice, as seen below:

```bash
npm run clone ../my-new-folder
```

If `my-new-folder` doesn't exist, it'll be created and have `git init` run against it. Then, all the important files from this repo will be copied to that folder, and `npm install` will be run after copying. Any files of the same name already existing in the target directory will be replaced, so be sure to not run this command against any directory with local changes.

---

### Folder Structure

There are three main folders that serve as the main basis for the app.

#### &nbsp;&nbsp;&nbsp;&nbsp;/Public

`/public`, which serves as the static content directory served by the `express.static()` method. By default, `/modules_server/main/endpoints.coffee` sets up these static files and also sets up the BoxyBrown routes for the client side JS and CSS.

#### &nbsp;&nbsp;&nbsp;&nbsp;/modules_server

A list of directories that map to server-side modules for use likely exclusively via Node. By default, the app will iterate through all directories here that aren't prefaced with an underscore, and automatically feed any routers returned from the `endpoints.coffee` coffee inside that sub-directory, to the main app Express router. See the [Endpoints Definition](#endpoints) for more information regarding creating these `endpoint.coffee` files.

By default, this directory comes with a `/_utilties` directory that includes common things to share amongst all the other server modules. Notice, that because its name starts with an underscore, it won't be parsed by the app when looking for endpoints to include.

<u>Default files included</u>

Path | Use
:--- | :---
`/_utilities/authenticated_route.coffee` | A default Express router to use for when the endpoints require an authenticated logged in user to complete
`/_utilities/open_route.coffee` | A default Express router to use for publicly accessible endpoints
`/_utilities/util.coffee` | A generic utility file that's used in some of the routes
`/main/endpoints.coffee` | Configures the routes for the static files, sets up the Browserify file paths, sets a global `m` variable to emulate the window for accessing Mithril, and finds & includes all the `endpoints.coffee` files [Endpoints Definition](#endpoints)


#### &nbsp;&nbsp;&nbsp;&nbsp;/modules_client

A list of directories that map to client-side modules (See [Module definition](#module)) that are likely to be served via Browserify or some other means to the browser. Like with `/modules_server`, the app will iterate through all directories here that aren't prefaced with an underscore, and automatically feed any routers returned from the `endpoints.coffee` coffee inside that sub-directory, to the main app Express router. See the [Endpoints Definition](#endpoints) for more information regarding creating these `endpoint.coffee` files.

By default, this directory comes with a `/_utilties` directory that includes common things to share amongst all the other client modules, and a `_components` directory that contains shared HTML views / controllers. Notice, that because its name starts with an underscore, it won't be parsed by the app when looking for endpoints to include.

<u>Default files included</u>

Path | Use
:--- | :---
`/_components/forms/desktop.coffee` | A default desktop form builder / utilities file
`/_utilities/secureAjax.coffee` | A wrapper around the default Mithril app extension AJAX function automatically includes the CSRF headers for meeting the `/modules_server/_utilities/authenticated_route.coffee` criteria
`/_utilties/utils.coffee` | A generic utility file that currently contains a method for invalidating a user session on the client-side
`/index/desktop.coffee` | The default controller and view for the root `/` path. See [Module definition](#module)
`/login/desktop.coffee` | An example login module that has both a client-side and server-side controller / view. See [Module definition](#module)
`/login/endpoints.coffee` | The server-side log in / log out endpoints for the above module [Endpoints Definition](#endpoints)
`/main/scss/defaults.scss` | A base SCSS file that would contain global rules shared between desktop and mobile experiences
`/main/scss/mixins.scss` | A global file for housing SCSS mixins to include in other files
`/main/desktop.coffee` | The upper-most desktop experience JS file that's injected to the browser via Browserify [See](https://github.com/msandow/mithril-app-template/blob/master/modules_server/main/endpoints.coffee#L13)
`/main/desktop.scss` | The upper-most desktop experience SCSS file that's injected to the browser via Browserify [See](https://github.com/msandow/mithril-app-template/blob/master/modules_server/main/endpoints.coffee#L20)

---

### <a name="endpoints"></a>Endpoints Definition

This file must export the following structure:

```javascript
module.exports = {
    scope: 'endpoint-foo/bar',
    router: new express.Router() || [new express.Router(), new express.Router()]
};
```

Here's a breakdown of the required properties being exported:

Property | Value 
:--- | :---
`scope` | The preface to use for all the defined routes when applied to the main application. Namespacing helps keep actions separate, and prevents collisions
`router` | Either an instance of a single Express router, or an array of Express routers should some of the routes require different permission levels

---

### <a name="module"></a>Module Definition

Each module is a simple object hash with the following properties:

Property | Value 
:--- | :---
`controller` | A class definition that stores all the properties and methods used inside the view. At render time, this will be turned into an instance of this class
`view` | A function which takes a single argument (the instance of the above class), and returns the tree of `m.el()` elements that represent the markup for the module
`route` | Either a single string, or an array of strings, which represents the route(s) which map to this specific module when requested from the app. For more examples see the [Mithril docs](http://lhorie.github.io/mithril/mithril.route.html)
`serverController` | Behaves exactly like `controller` above, except, if defined, this will be used instead when [m.toString](#app-tostring) is called. Useful for changing properties, or where property data comes from, when generating static server-side views for SEO purposes. Unlike the regular `controller`, the `serverController` has a special signature, which you can find described below

**serverController Arguments**
* `request` - The Express request object for the matched route
* `response` - The Express response object for the matched route
* `viewTriggerFunction` - A function to indicate that the controller is complete enough for the server to use it to generate a view. In the browser, we can redraw the DOM as much as we want as events happen, but in Node we only get a single response that can be sent to the client. As such, you call this method when any events your serverController needs to acquire all necessary data are complete. If you never call this method, no response will be sent.

---

### <a name="extension"></a>Mithril App Extension Methods

* [m.query](#app-query)
* [m.matches](#app-matches)
* [m.ready](#app-ready)
* [m.register](#app-register)
* [m.start](#app-start)
* [m.component](#app-component)
* [m.refresh](#app-refresh)
* [m.el](#app-el)
* [m.ajax](#app-ajax)
* [m.extend](#app-extend)
* [m.multiClass](#app-multiclass)
* [m.toString](#app-tostring)

#### <a name="app-query"></a>m.query(selectorOrRootElement, [selector])
An element querying function that returns either an array of matched elements, or a single element if the matched set has only a single item in it.

**Arguments**
* `selectorOrRootElement` - When the second parameter is omitted, this acts as the CSS selector of the element(s) in the DOM to search for
* `selector` - When used, this optional selector behaves exactly as above, but instead of searching the entire document, it starts searching from the element provided in `selectorOrRootElement`

<p>&nbsp;</p>

#### <a name="app-tostring"></a>m.toString(module, callback, [request, response])
Takes a defined `module` and renders it to pure HTML, for use in server-side rendering of a client-side module. Strips any functions / events from rendered elements. This method is asynchronous, and the final HTML is returned as the sole argument passed to the `callback` function.

**Arguments**
* `module` - The Mithril app module to render (see [Module definition](#module))
* `callback` - The function to call when rendering is complete. Gets passed a single argument, which is the final string of compiled HTML
* `request` - The optional Express request object, for use inside a module's `serverController` (see [Module definition](#module)), should the controller need access to parameters or other request data
* `response` - The optional Express response object, for use inside a module's `serverController` (see [Module definition](#module))

<p>&nbsp;</p>

#### <a name="app-matches"></a>m.matches(element, selector)
Takes an element and returns a boolean that describes whether or not it matches the selector provided. Useful for binding events high in the DOM, and only firing with a bubbled event target matches certain conditions.

**Arguments**
* `element` - The DOM element to inspect
* `selector` - The string CSS selector to compare the element against

<p>&nbsp;</p>

#### <a name="app-ready"></a>m.ready(callback)
A method similar to jQuery's `$(document).ready(function(){})`, or `$(function(){})`, that you can call any number of times, each time passing in a function to call when the Mithril app is ready. If called before readyState, the functions are queued in order, otherwise they're invoked immediately. 

**Arguments**
* `callback` - The function to run when ready

<p>&nbsp;</p>

#### <a name="app-register"></a>m.register(module)
Takes a defined `module` and registers it for use when [m.start](#app-start) is called. All modules that are accessible via URL routes **must** be registered.

**Arguments**
* `module` - The Mithril app module to render (see [Module definition](#module))

<p>&nbsp;</p>

#### <a name="app-start"></a>m.start(rootElement)
Starts the Mithril routing engine, drawing all matched routes / modules into the defined `rootElement`. Any modules registered after calling start won't appear in the application.

**Arguments**
* `rootElement` - The DOM element that serves as the container for all the views. Generally this is the body tag

<p>&nbsp;</p>

#### <a name="app-component"></a>m.component(module)
Creates a component out of any Mithril module, and returns a function that can be invoked to return that components's view contents. Unlike a traditional module, a component is meant to be abstracted away, and shared in many other modules, behaving like a sub-module. Since new controllers should never be instantiated inside views, the component method calls the passed module's controller only once, and then itself acts as a function that gets the view with that controller fed to it.

**Arguments**
* `module` - The Mithril module (see [Module definition](#module)) that acts as the basis for the component

**Example**

```javascript
var pageHeader = m.component({
    controller: function(){
        this.userName = 'Foo bar';
        this.whoAmI = function(){
            alert(this.userName);
        };
    },
    view: function(ctrl){
        return m.el('header',[
            m.el('a',{
                onclick: ctrl.whoAmI
            })
        ]);
    }
});

var someRealModule = {
    controller: function(){},
    view: function(ctrl){
        return [
            pageHeader(),
            m.el('section',"Hello, I'm a module")
        ];
    }
};

m.register(someRealModule);
```

<p>&nbsp;</p>

#### <a name="app-refresh"></a>m.refresh()
A helper method that "refreshes" the current app route (not a window refresh). It's a short hand for manually routing to the current route the user is already on, thus instantiating a controller and triggering the view to redraw.

<p>&nbsp;</p>

#### <a name="app-el"></a>m.el(tag, hashOrChildren, [children])
A proxy for the out-of-the-box Mithril m() function, with the benefit of monitoring all elements that event event handlers bound to them, and converting those to event listeners which are automatically unbound anytime the view is destroyed.

**Arguments**

See the [Mithril docs](http://lhorie.github.io/mithril/mithril.html#usage)

<p>&nbsp;</p>

#### <a name="app-ajax"></a>m.ajax(configs)
A wrapper around the default `m.request()` method, but structured to behave more like the jQuery ajax function. Instead of returning a promise as the default `m.request()` does, it return the XHR object, thus making it cancellable easily.

**Arguments**

It takes a single `configs` object, which accepts properties as defined below: 

Property | Value
--- | ---
`method` | Either `GET`, `POST`, `HEAD`, `PUT`, or `DELETE`
`data` | An optional object that represents either the body data for `PUT`, `DELETE` or `POST` requests, or querystring params for `GET`, and `HEAD` requests
`headers` | An optional object that represents key-value pairs of data to send along in the headers of the request
`complete` | A function to call on completion or abortion of the underlying XHR request. It takes two parameters: (`error`, `data`). `error` is the information passed back from any non-successful completion or `null` if successful, and `data` is the information passed back from a successul completion or `null` if unsuccessful

<p>&nbsp;</p>

#### <a name="app-extend"></a>m.extend(to, from)
Much like `jQuery.extend()`, this methods takes properties from the `from` object and applies them to the `to` object. This process is recursive, so anyone sub-objects from both objects will be extended instead of being replaced entirely.

**Arguments**

See the [Mithril docs](http://lhorie.github.io/mithril/mithril.html#usage)

<p>&nbsp;</p>

#### <a name="app-multiclass"></a>m.multiClass(subClass1, [subClassN...])
For those of us that develop in CoffeeScript, this method allows for composition of many aritrary subclasses onto a new class when passed to Coffee's built in `extend` functionality.

**Example**

```coffeescript
  FooClass = class
    constructor: ->
      @className = 'foo'
    
    identify: ->
      @className
  
  BarClass = class
    constructor: ->
      @className = 'bar'
    
    amIFoo: ->
      @className is 'foo'
  
  FinalClass = class extends m.multiClass(FooClass, BarClass)
    constructor: (@someNumber)->

  
  made = new FinalClass(3)
  
  made.someNumber
  # 3
  
  m.className
  # 'bar'
  
  m.amIFoo()
  # false
  
  m.identify()
  # 'bar'
```