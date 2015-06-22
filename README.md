Quick Mithril App
=================

### Uses

By doing a bare Git clone of this repository, you quickly get access to an app server that's based of the [Mithril MVC](http://lhorie.github.io/mithril/mithril.html), with a custom extension file that makes configuring a Mithril app a little more consistent. This combination not only makes for an extremely performant client-side app, but also uses the client-side views to create static server-side views too, so that all routes are crawler accesible and SEO friendly without having to set up a bunch of separate routes.

Please refer to the [Mithril App Extension](#extension) section to see more info about what the extension provides.

---

### Folder structure

There are three main folders that serve as the main basis for the app.

#### &nbsp;&nbsp;&nbsp;&nbsp;/Public

`/public`, which serves as the static content directory served by the `express.static()` method. By default, `/modules_server/main/endpoints.coffee` sets up these static files and also leverages the `setHeaders` option to set the proper content-type for `.map` files, so that browsers can format and color code the files properly.

#### &nbsp;&nbsp;&nbsp;&nbsp;/modules_server

A list of directories that map to server-side modules for use likely exclusively via Node. By default, the app will iterate through all directories here that aren't prefaced with an underscore, and automatically feed any routers returned from the `endpoints.coffee` coffee inside that sub-directory, to the main app Express router. See the [Endpoints Definition](#endpoints) for more information regarding creating these `endpoint.coffee` files.

By default, this directory comes with a `/_utilties` directory that includes common things to share amongst all the other server modules. Notice, that because its name starts with an underscore, it won't be parsed by the app when looking for endpoints to include.

<u>Default files included</u>

Path | Use
:--- | :---
`/_utilities/authenticated_route.coffee` | A default Express router to use for when the endpoints require an authenticated logged in user to complete
`/_utilities/open_route.coffee` | A default Express router to use for publicly accessible endpoints
`/_utilities/util.coffee` | A generic utility file that's used in some of the routes
`/main/endpoints.coffee` | Configures the routes for the static files, sets up the Browserify file paths, and finds & includes all the `endpoints.coffee` files [Endpoints Definition](#endpoints)


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

#### &nbsp;&nbsp;&nbsp;&nbsp;<a name="app-query"></a>m.query(selectorOrRootElement, [selector])
An element querying function that returns either an array of matched elements, or a single element if the matched set has only a single item in it.

**Arguments**
* `selectorOrRootElement` - When the second parameter is omitted, this acts as the CSS selector of the element(s) in the DOM to search for
* `selector` - When used, this optional selector behaves exactly as above, but instead of searching the entire document, it starts searching from the element provided in `selectorOrRootElement`

<p>&nbsp;</p>

#### &nbsp;&nbsp;&nbsp;&nbsp;<a name="app-tostring"></a>m.toString(module, callback, [request, response])
Takes a defined `module` and renders it to pure HTML, for use in server-side rendering of a client-side module. Strips any functions / events from rendered elements. This method is asynchronous, and the final HTML is returned as the sole argument passed to the `callback` function.

**Arguments**
* `module` - The Mithril app module to render (see [Module definition](#module))
* `callback` - The function to call when rendering is complete. Gets passed a single argument, which is the final string of compiled HTML
* `request` - The optional Express request object, for use inside a module's `serverController` (see [Module definition](#module)), should the controller need access to parameters or other request data
* `response` - The optional Express response object, for use inside a module's `serverController` (see [Module definition](#module))

<p>&nbsp;</p>

#### &nbsp;&nbsp;&nbsp;&nbsp;<a name="app-matches"></a>m.matches(element, selector)
Takes an element and returns a boolean that describes whether or not it matches the selector provided. Useful for binding events high in the DOM, and only firing with a bubbled event target matches certain conditions.

**Arguments**
* `element` - The DOM element to inspect
* `selector` - The string CSS selector to compoare te element against