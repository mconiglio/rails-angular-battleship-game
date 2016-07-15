'use strict';

angular
  .module('battleshipApp.flash')
  .service('FlashService', FlashService);

FlashService.$inject = ['$rootScope'];

function FlashService($rootScope) {
  var queue = [], currentMessage = '';

  $rootScope.$on('$routeChangeSuccess', function() {
    if (queue.length > 0)
      currentMessage = queue.shift();
    else
      currentMessage = '';
  });

  return {
    set: function(message) {
      queue.push(message);
    },
    get: function() {
      return currentMessage;
    }
  };
}
