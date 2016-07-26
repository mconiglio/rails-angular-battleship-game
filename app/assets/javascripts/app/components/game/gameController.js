'use strict';

angular
  .module('battleshipApp.core')
  .controller('GameController', GameController);

GameController.$inject = ['$location', '$routeParams', '$interval', 'hotkeys', 'GameService', 'SessionService'];

function GameController($location, $routeParams, $interval, hotkeys, GameService, SessionService) {
  var vm = this;

  vm.shootPosition = shootPosition;
  vm.game = {};
  vm.positions = [];
  vm.time_played = 0;
  vm.x_selected = 1;
  vm.y_selected = 1;

  getGame($routeParams.id);
  showTime();

  hotkeys.add('left', function(event){if (vm.x_selected > 1) vm.x_selected -= 1; event.preventDefault();});
  hotkeys.add('right', function(event){if (vm.x_selected < 10) vm.x_selected += 1; event.preventDefault();});
  hotkeys.add('up', function(event){if (vm.y_selected > 1) vm.y_selected -= 1; event.preventDefault();});
  hotkeys.add('down', function(event){if (vm.y_selected < 10) vm.y_selected += 1; event.preventDefault();});
  hotkeys.add('space', function(event){
    var position = vm.positions[vm.y_selected - 1][vm.x_selected - 1];
    vm.shootPosition(position);
    event.preventDefault();
  });

  function getGame(id) {
    GameService.getGame(id).then(function(game) {
      vm.game = game.data;
      if (vm.game.user.email == SessionService.getUser()){
        var i, k;

        for (i = 0, k = -1; i < vm.game.positions.length; i++) {
          if (i % 10 === 0) {
            k++;
            vm.positions[k] = [];
          }
          vm.positions[k].push(vm.game.positions[i]);
        }
      } else {
        $location.path('/');
      }
    }, function () {
      $location.path('/');
    });
  }

  function showTime() {
    $interval(function() {
      if (vm.game.ended_at == null) {
        var currentTime = new Date();
        var secondsPast = (currentTime.getTime() - new Date(vm.game.created_at).getTime()) / 1000;
        vm.time_played = parseInt(secondsPast);
      }
    }, 1000);
  }

  function shootPosition(position) {
    if (!position.shooted && !vm.game.ended_at) {
      GameService.shootPosition(position.id ,vm.game.id)
        .then(function (updated_position) {
          vm.game = updated_position.data.game;
          vm.positions[position.y - 1][position.x - 1] = updated_position.data;
        });
    }
  }
}