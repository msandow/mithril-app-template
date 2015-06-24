fs = require('fs')
path = require('path')
PWD = path.resolve(__dirname, '..')
async = require('async')
exec = require('child_process').exec
needToInit = false



if not process.argv[2]
  console.error('No destination directory passed')
  return



cloneTree = [
  'app.js'
  'main.coffee'
  'package.json'
  'modules_client/'
  'modules_server'
  'public/'
]



expandedCloneTree = []



DIR = path.resolve(PWD, process.argv[2])


async.series([
  (cb)->
    fs.exists(DIR, (ex)->
      if not ex
        console.log("Directory #{DIR} doesn't exist. Creating.")
        fs.mkdir(DIR,()->
          needToInit = true
          cb()
        )
      else
        cb()
    )

  (cb)->
    if not needToInit
      cb()
      return
    
    cloneTree.unshift(".gitignore", "package.json")
    
    exec("cd #{DIR} && git init && cd #{PWD}", ()->
      cb()
    )

  (cb)->
    cloneTree = cloneTree.map((p)->
      path.resolve(PWD, p)
    )
    cb()

  (cb)->
    q = async.queue((item, qcb)->
      fs.stat(item, (err, stats)->
        if stats.isDirectory()
          expandedCloneTree.push(item+"/")
          fs.readdir(item, (err, files)->
            for fi in files
              q.push(path.resolve(item, fi))
            qcb()
          )
        else
          expandedCloneTree.push(item)
          qcb()
      )
    , 2)

    q.drain = ()->
      cb()
    
    q.push(cloneTree)

  (cb)->
    cloneTree.length = 0
    expandedCloneTree = expandedCloneTree.map((i)->
      {
        from: i
        to: i.replace(PWD, DIR)
      }
    )
    cb()

  (cb)->
    async.series(expandedCloneTree.map((i)->
      (scb)->
        if i.from[i.from.length-1] is '/'
          
          fs.exists(i.to, (ex)->
            if not ex
              fs.mkdir(i.to,()->
                scb()
              )
            else
              scb()
          )
        
        else

          rd = fs.createReadStream(i.from)          
          rd.on('error',()-> scb())
          
          wr = fs.createWriteStream(i.to)
          wr.on('error',()-> scb())
          wr.on('close',()-> scb())
          
          rd.pipe(wr)
        
    ), (err, results)->
      console.log("#{expandedCloneTree.length} files / directories copied")
      cb()
    )

  (cb)->
    fs.readFile(DIR + "/package.json", {encoding: 'utf8'}, (err, data)->
      fs.writeFile(DIR + "/package.json", data
        .replace(/[\t\s]+"async":[\t\s]*".{1,1}[\d\.]+",*[\r\n]*/gim, '\r')
        .replace(/"name":[\t\s]*"(.*?)"/gim, '"name": ""')
        .replace(/[\t\s]+"clone":[\t\s]*"node_modules\/\.bin\/coffee\sbin\/clone\.coffee",*[\r\n]*/gim, '\r')
        ,
        ()->
          cb()
      )
    )

  (cb)->
    fs.exists(DIR + "/node_modules", (ex)->
      if ex
        cb()
      else
        console.log("Installing node modules")
        exec("cd #{DIR} && npm install && cd #{PWD}", ()->
          cb()
        )
    )
    
],(err, results)->
  console.log("Clone complete")
)