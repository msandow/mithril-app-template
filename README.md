Quick Mithril App
=================

### Uses

By doing a bare Git clone of this repository, you quickly get access to an app server that's based of the [Mithril MVC](http://lhorie.github.io/mithril/mithril.html), with a custom extension file that makes configuring a Mithril app a little more consistent. This combination not only makes for an extremely performant client-side app, but also uses the client-side views to create static server-side views too, so that all routes are crawler accesible and SEO friendly without having to set up a bunch of separate routes.

Please refer to the [Mithril App Extension](#extension) section to see more info about what the extension provides.

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
`/main/endpoints.coffee` | Configures the routes for the static files, sets up the Browserify file paths, and finds & includes all the `endpoints.coffee` files


#### &nbsp;&nbsp;&nbsp;&nbsp;/modules_client

A list of directories that map to client-side modules that are likely to be served via Browserify or some other means to the browser. Like with `/modules_server`, the app will iterate through all directories here that aren't prefaced with an underscore, and automatically feed any routers returned from the `endpoints.coffee` coffee inside that sub-directory, to the main app Express router. See the [Endpoints Definition](#endpoints) for more information regarding creating these `endpoint.coffee` files.

By default, this directory comes with a `/_utilties` directory that includes common things to share amongst all the other client modules, and a `_components` directory that contains shared HTML views / controllers. Notice, that because its name starts with an underscore, it won't be parsed by the app when looking for endpoints to include.

<u>Default files included</u>

Path | Use
:--- | :---
`/_components/forms/desktop.coffee` | A default desktop form builder / utilities file
`/_utilities/secureAjax.coffee` | A wrapper around the default Mithril app extension AJAX function automatically includes the CSRF headers for meeting the `/modules_server/_utilities/authenticated_route.coffee` criteria
`/_utilties/utils.coffee` | A generic utility file that currently contains a method for invalidating a user session on the client-side
`/index/desktop.coffee` | The default controller and view for the root `/` path
`/login/desktop.coffee` | An example login module that has both a client-side and server-side controller / view
`/login/endpoints.coffee` | The server-side log in / log out endpoints for the above module
`/main/scss/defaults.scss` | A base SCSS file that would contain global rules shared between desktop and mobile experiences
`/main/scss/mixins.scss` | A global file for housing SCSS mixins to include in other files
`/main/desktop.coffee` | The upper-most desktop experience JS file that's injected to the browser via Browserify
`/main/desktop.scss` | The upper-most desktop experience SCSS file that's injected to the browser via Browserify



### <a name="extension"></a>Mithril App Extension

```javascript
Router.use(express.static(
    "/myPublicFolder",
    {
        setHeaders: function(res, file, stats){
            if(/\.map$/i.test(file) && !res.headersSent){
                res.set('Content-Type', 'application/json');
            }
        }
    }
));
```
### <a name="endpoints"></a>Mithril App Extension
### <a name="extension"></a>Endpoints Definition