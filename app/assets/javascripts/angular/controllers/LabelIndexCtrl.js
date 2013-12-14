
this.deskapp.controller('LabelIndexCtrl', ['$scope', '$location', $'http', function($scope, $location, $http)
{
  $scope.labels = [] ;
  $http.get('./labels.json').success( function(data)
  {
    $scope.labels = data;
  });

	$scope.addLabel = function()
	{
		 $http.get('./addlabel.json').success( function(data)
	  {
	  	alert(data.message);
	    if(data.status == "success")	    
	    	$scope.labels.push(data.message);
	  })
		 .error(function(data)
		 {
		 		alert('An error occured adding label!');
		 });
		 
	};
}]
);