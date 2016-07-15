'use strict';

angular.module('battleshipApp.user', []);
angular.module('battleshipApp.flash', []);

angular.module('battleshipApp', [
  'ngRoute',
  'Devise',
  'battleshipApp.user',
  'battleshipApp.session',
  'battleshipApp.flash'
]);
