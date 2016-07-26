'use strict';

angular
  .module('battleshipApp.session')
  .service('SessionService', SessionService);

function SessionService() {
  var currentUser = '', isAuthenticated = false;

  return {
    setUser: function(user) {
      currentUser = user;
    },
    getUser: function() {
      return currentUser;
    },
    setAuthenticated: function(authenticated) {
      isAuthenticated = authenticated;
    },
    getAuthenticated: function() {
      return isAuthenticated;
    }
  };
}
