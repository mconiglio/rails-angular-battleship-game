'use strict';

angular
  .module('battleshipApp.core')
  .service('LeaderboardService', LeaderboardService);

LeaderboardService.$inject = ['$http'];

function LeaderboardService($http) {

  this.getTopPlayers = function (page) {
    return $http.get('/leaderboards/?page=' + page);
  }

  this.getLastGames = function (page) {
    return $http.get('/games/?page=' + page);
  }
};
