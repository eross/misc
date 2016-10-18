angular.module('calculatorApp', []).controller('CalculatorController', function CalculatorController($scope) {
  $scope.sum = function() {
    $scope.z = $scope.x + $scope.y;
  };
});

