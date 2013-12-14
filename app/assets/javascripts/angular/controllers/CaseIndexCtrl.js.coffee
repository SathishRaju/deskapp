# app/assets/javascripts/angular/controllers/CaseIndexCtrl.js.coffee

@deskapp.controller 'CaseIndexCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->
  $scope.cases = []
  $http.get('./cases.json').success((data) ->
    $scope.cases = data
  )
]