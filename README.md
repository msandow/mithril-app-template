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

A list of directories that map to server-side modules for use likely exclusively via Node. By default, the app will iterate through all directories here that aren't prefaced with an underscore, and automatically feed any routers returned from the `endpoints.coffee` coffee inside that sub-directory, to the main app Express router. See the [Endpoints Definiation](#endpoints) for more information regarding creating these `endpoint.coffee` files.

By default, this directory comes with a `/_utilties` directory that includes common things to share amongst all the other server modules. Notice, that because its name starts with an underscore, it won't be parsed by the app when looking for endpoints to include.

#### &nbsp;&nbsp;&nbsp;&nbsp;/modules_client

A list of directories that map to client-side modules that are likely to be served via Browserify or some other means to the browser. Like with `/modules_server`, the app will iterate through all directories here that aren't prefaced with an underscore, and automatically feed any routers returned from the `endpoints.coffee` coffee inside that sub-directory, to the main app Express router. See the [Endpoints Definiation](#endpoints) for more information regarding creating these `endpoint.coffee` files.

By default, this directory comes with a `/_utilties` directory that includes common things to share amongst all the other client modules, and a `_components` directory that contains shared HTML views / controllers. Notice, that because its name starts with an underscore, it won't be parsed by the app when looking for endpoints to include.

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
### <a name="extension"></a>Mithril App Extension