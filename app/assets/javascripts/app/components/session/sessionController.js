'use strict';

angular
  .module('battleshipApp.session')
  .controller('SessionController', SessionController);

SessionController.$inject = ['Auth', '$rootScope', 'SessionService', '$location'];

function SessionController(Auth, $rootScope, SessionService, $location) {
  var vm = this;

  vm.currentUser = currentUser;
  vm.isAuthenticated = isAuthenticated;
  vm.isGuest = isGuest;
  vm.currentUserName = currentUserName;

  function currentUser() {
    return SessionService.getUser();
  }

  function isAuthenticated() {
    return SessionService.getAuthenticated();
  }

  function isGuest() {
    return SessionService.getGuest();
  }

  function currentUserName() {
    return SessionService.getGuest() ? 'Guest' : SessionService.getUser();
  }

  Auth.currentUser().then(function(user) {
    SessionService.setAuthenticated(true);
    SessionService.setUser(user.email);
    var userIsGuest = /^guest_\d*@example.com$/.test(user.email);
    SessionService.setGuest(userIsGuest);
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
    SessionService.setGuest(true);
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
