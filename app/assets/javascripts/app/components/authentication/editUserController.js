'use strict';

angular
  .module('battleshipApp.user')
  .controller('EditUserController', EditUserController);

EditUserController.$inject = ['$location', 'FlashService', 'UserService'];

function EditUserController($location, FlashService, UserService) {
  var vm = this;
  vm.credentials = { password: '', password_confirmation: '', current_password: '' };

  vm.edit = function() {
    delete vm.error;
    vm.dataLoading = true;

    UserService.editUser(vm.credentials)
      .then(function(user) {
        FlashService.set('Successfully update your password!');
        $location.path('/');
      }, function(error) {
        vm.error = error.data.error;
        vm.dataLoading = false;
      });
  }
}
;