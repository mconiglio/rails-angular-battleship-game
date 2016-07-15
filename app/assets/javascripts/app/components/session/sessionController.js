'use strict';

angular
  .module('battleshipApp.session', [])
  .controller('SessionController', SessionController);

SessionController.$inject = ['Auth', '$scope', '$location'];

function SessionController(Auth, $scope, $location) {

  Auth.currentUser().then(function(user) {
    $scope.currentUser = user.email;
    $scope.isAuthenticated = true;
  });

  $scope.$on('devise:login', function() {
    $scope.isAuthenticated = true;
  });

  $scope.$on('devise:new-session', function() {
    $scope.isAuthenticated = true;
  });

  $scope.$on('devise:logout', function() {
    $scope.isAuthenticated = false;
    delete $scope.currentUser;
  });

  $scope.$on('devise:new-registration', function() {
    $scope.isAuthenticated = true;
  });

  this.logout = function() {
    Auth.logout().then(function() {
      $location.path("/");
    });
  }
}
