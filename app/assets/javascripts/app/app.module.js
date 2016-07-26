'use strict';

angular.module('battleshipApp.user', []);
angular.module('battleshipApp.session', []);
angular.module('battleshipApp.core', []);

angular.module('battleshipApp', [
  'ngRoute',
  'Devise',
  'battleshipApp.user',
  'battleshipApp.session',
  'battleshipApp.core',
  'cfp.hotkeys'
]);
