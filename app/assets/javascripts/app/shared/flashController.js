'use strict';

angular
  .module('battleshipApp.session')
  .controller('FlashController', FlashController);

FlashController.$inject = ['FlashService'];

function FlashController(FlashService) {
  var vm = this;

  vm.get = function() {
    return FlashService.get();
  };

  vm.set = function(message) {
    FlashService.set(message);
  }
}