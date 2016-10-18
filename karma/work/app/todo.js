// scope –hold items on the controller
var scope = {};
beforeEach(function(){
//...
//inject – access angular controllerinject(function($controller){
  //$controller – initialize controller with test scope
  $controller('TodoController',{$scope:scope});
});
//... });
