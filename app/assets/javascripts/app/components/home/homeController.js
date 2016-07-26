'use strict';

angular.module('battleshipApp.core')
  .controller('HomeController', HomeController);

HomeController.$inject = ['$location', 'GameService'];


function HomeController($location, GameService) {
  var vm = this;

  vm.createGame = createGame;

  function createGame() {
    GameService.createGame().then(function (game) {
      $location.path('/game/' + game.data.id);
    });
  }
};
