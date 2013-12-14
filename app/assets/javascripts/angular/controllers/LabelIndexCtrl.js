
this.deskapp.controller('LabelIndexCtrl', ['$scope', '$location', '$http', function($scope, $location, $http)
{
  $scope.labels = [] ;
  $http.get('./labels.json').success( function(data)
  {
    $scope.labels = data;
  });

	$scope.addLabel = function()
	{
		 $http.get('./addlabel.json', {params: {labelname: $scope.labelname}}).success( function(data)
	  {
	    if(data.status == "success")	    
	    	$scope.labels.push(data.label);
	    else
	    	alert(data.message);
	  })
		 .error(function(data)
		 {
		 		alert('An error occured adding label!');
		 });
		 
	};
}]
);