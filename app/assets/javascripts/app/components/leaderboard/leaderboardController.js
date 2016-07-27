'use strict';

angular
  .module('battleshipApp.core')
  .controller('LeaderboardController', LeaderboardController);

LeaderboardController.$inject = ['LeaderboardService', 'GameService', '$location'];

function LeaderboardController(LeaderboardService, GameService, $location) {
  var vm = this;

  vm.lastGamesPreviousPage = lastGamesPreviousPage;
  vm.lastGamesNextPage = lastGamesNextPage;
  vm.topPlayersPreviousPage = topPlayersPreviousPage;
  vm.topPlayersNextPage = topPlayersNextPage;
  vm.createGame = createGame;

  vm.topPlayers = [];
  vm.topPlayersPage = 1;
  vm.topPlayersTotalPages = 0;

  vm.lastGames = [];
  vm.lastGamesPage = 1;
  vm.lastGamesTotalPages = 0;

  getTopPlayers();
  getLastGames();

  function getTopPlayers() {
    LeaderboardService.getTopPlayers(vm.topPlayersPage).then(function(topPlayers) {
      vm.topPlayers = topPlayers.data.users;
      vm.topPlayersTotalPages = topPlayers.data.total_pages;
    });
  }

  function getLastGames() {
    LeaderboardService.getLastGames(vm.lastGamesPage).then(function(lastGames) {
      vm.lastGames = lastGames.data.games;
      vm.lastGamesTotalPages = lastGames.data.total_pages;
    });
  }

  function lastGamesPreviousPage() {
    if (vm.lastGamesPage > 1) {
      vm.lastGamesPage -= 1;
      getLastGames();
    }
  }

  function lastGamesNextPage() {
    if (vm.lastGamesPage < vm.lastGamesTotalPages) {
      vm.lastGamesPage += 1;
      getLastGames();
    }
  }

  function topPlayersPreviousPage() {
    if (vm.topPlayersPage > 1) {
      vm.topPlayersPage -= 1;
      getTopPlayers();
    }
  }

  function topPlayersNextPage() {
    if (vm.topPlayersPage < vm.topPlayersTotalPages) {
      vm.topPlayersPage += 1;
      getTopPlayers();
    }
  }

  function createGame() {
    GameService.createGame().then(function (game) {
      $location.path('/game/' + game.data.id);
    });
  }
};
