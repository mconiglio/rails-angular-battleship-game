'use strict';

angular
  .module('battleshipApp.user')
  .controller('SignUpController', SignUpController);

SignUpController.$inject = ['Auth', '$location', 'FlashService'];

function SignUpController(Auth, $location, FlashService) {
  var vm = this;
  vm.credentials = { email: '', password: '', password_confirmation: '' };

  vm.signUp = function() {
    delete vm.error;
    vm.dataLoading = true;

    Auth.register(vm.credentials).then(function(registeredUser) {
      FlashService.set('Successfully registered as ' + registeredUser.email + '!');
      $location.path('/');
    }, function(error) {
      vm.error = error.data.error;
      vm.dataLoading = false;
    });
  }
}