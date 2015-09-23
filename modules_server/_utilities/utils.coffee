module.exports = 
  getUTCTime: () ->
    now = new Date()
    now_utc = new Date(now.getTime() + now.getTimezoneOffset() * 60000)
    now.getTime()
  
  getReqIP: (req) ->
    req.headers['x-forwarded-for'] or req.connection.remoteAddress or req.ip or ""