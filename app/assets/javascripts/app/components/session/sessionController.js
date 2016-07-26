'use strict';

angular
  .module('battleshipApp.session')
  .controller('SessionController', SessionController);

SessionController.$inject = ['Auth', '$rootScope', 'SessionService', '$location'];

function SessionController(Auth, $rootScope, SessionService, $location) {
  var vm = this;

  vm.currentUser = currentUser;
  vm.isAuthenticated = isAuthenticated;

  function currentUser() {
    return SessionService.getUser();
  }

  function isAuthenticated() {
    return SessionService.getAuthenticated();
  }

  Auth.currentUser().then(function(user) {
    SessionService.setUser(user.email);
    SessionService.setAuthenticated(true);
  });

  $rootScope.$on('devise:login', function() {
    SessionService.setAuthenticated(true);
  });

  $rootScope.$on('devise:new-session', function() {
    SessionService.setAuthenticated(true);
  });

  $rootScope.$on('devise:logout', function() {
    SessionService.setAuthenticated(false);
    SessionService.setUser('');
  });

  $rootScope.$on('devise:new-registration', function() {
    SessionService.setAuthenticated(true);
  });

  this.logout = function() {
    Auth.logout().then(function() {
      $location.path("/");
    });
  }
}
