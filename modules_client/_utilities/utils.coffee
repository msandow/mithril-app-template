module.exports = 
  
  invalidateUser: (path = '/login') ->
    window.localStorage.removeItem('currentUser')
    window.localStorage.removeItem('csrf')
    m.route(path)