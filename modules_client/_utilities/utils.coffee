module.exports = 
  
  invalidateUser: (path = '/login') ->
    window.sessionStorage.removeItem('currentUser')
    window.sessionStorage.removeItem('csrf')
    m.route(path)