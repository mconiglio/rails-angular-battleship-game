'use strict';

angular
  .module('battleshipApp.user')
  .controller('SignInController', SignInController);

SignInController.$inject = ['Auth', '$location', 'FlashService'];

function SignInController(Auth, $location, FlashService) {
  var vm = this;
  vm.credentials = { email: '', password: '' };

  vm.signIn = function() {
    delete vm.error;
    vm.dataLoading = true;

    Auth.login(vm.credentials).then(function(user) {
      FlashService.set('Successfully logged in as ' + user.email + '!');
      $location.path('/');
    }, function(error) {
      vm.error = error.data.error;
      vm.dataLoading = false;
    });
  }
}