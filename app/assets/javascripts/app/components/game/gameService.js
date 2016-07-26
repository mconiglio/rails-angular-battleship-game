'use strict';

angular
  .module('battleshipApp.core')
  .service('GameService', GameService);

GameService.$inject = ['$http'];

function GameService($http) {

  this.getGame = function (id) {
    return $http.get('/games/' + id + '.json');
  }

  this.shootPosition = function (id, game_id) {
    return $http.put('/games/' + game_id + '/positions/' + id);
  }

  this.createGame = function () {
    return $http.post('/games.json');
  }
};