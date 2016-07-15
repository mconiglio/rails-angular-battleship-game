'use strict';

angular
  .module('battleshipApp.user')
  .service('UserService', UserService);

UserService.$inject = ['$http'];

function UserService($http) {

  this.editUser = function (credentials) {
    return $http.put('/users.json', { user: credentials });
  }
};