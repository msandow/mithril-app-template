module.exports = 
  
  invalidateUser: (path = '/user') ->
    window.localStorage.removeItem('currentUser')
    window.localStorage.removeItem('csrf')
    m.route(path)