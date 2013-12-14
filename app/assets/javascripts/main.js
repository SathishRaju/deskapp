

var deskapp = angular.module('deskapp', ['ngRoute']);

deskapp.config([
  "$httpProvider", function($httpProvider) {
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    $httpProvider.defaults.useXDomain = true;
  }
]);

deskapp.config(['$routeProvider', function($routeProvider)
{
	$routeProvider.
    when('/labels', {
    templateUrl: '../templates/labels/index.html',
    controller: 'LabelIndexCtrl'
    }).
  	when('/cases', {
      templateUrl: '../templates/cases/index.html',
      controller: 'CaseIndexCtrl'
    }).
    otherwise({
      templateUrl: '../templates/home.html',
      controller: 'HomeCtrl'
    })
   } 
]);