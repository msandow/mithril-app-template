Quick Mithril App
=================

### Folder structure

There are three main folders that serve as the main basis for the app. `/public`, which serves as the static content directory served by the `express.static()` method. We can also leverage this method to set custom headers for `.map` files, so that browsers can format and color code the files properly. See below:

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