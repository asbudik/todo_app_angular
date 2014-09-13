TodoApp = angular.module("TodoApp", ["ngRoute", "templates"])

TodoApp.config ["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider) ->
  $routeProvider
    .when '/',
      templateUrl: "index.html",
      controller: "TodosCtrl"
  .otherwise
    redirectTo: "/"

  $locationProvider.html5Mode(true).hashPrefix("#")

]

TodoApp.controller "TodosCtrl", ["$scope", "$http", ($scope, $http) ->
  $scope.todos = []

  $scope.getTodos = ->
    $http.get("/todos.json").success (data) ->
      $scope.todos = data

  $scope.getTodos()

  $scope.addTodo = ->
    console.log($scope.newTodo)
    $http.post("/todos.json", $scope.newTodo).success (data) ->
      $scope.newTodo = {}

      $scope.todos.push(data)

  $scope.deleteTodo = (task) ->
    conf = confirm "Delete this task?"
    if conf
      $http.delete("/todos/#{task.id}.json").success (data) ->
        $scope.todos.splice($scope.todos.indexOf(task), 1)

  $scope.editTodo = (task) ->
    this.checked = false
    $http.put("/todos/#{task.id}.json", task).success (data) ->


]

TodoApp.config ["$httpProvider", ($httpProvider)->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]