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
  $scope.fadetask = true
  $scope.notice = "Edit"


  $scope.getTodos = ->
    $http.get("/todos.json").success (data) ->
      $scope.todos = data
      for i in $scope.todos
        $scope["completecheckbox" + i.id] = false

      for i in $scope.todos
        if i.complete == 1
          $scope["completecheckbox" + i.id] = true


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
    this.notice = "Edit"

    $http.put("/todos/#{task.id}.json", task).success (data) ->

  $scope.checkButton = () ->
    if this.checked == true
      console.log("true")
      this.checked = false
      this.notice = "Edit"
    else
      console.log("setting true")
      this.notice = "Close"
      this.checked = true

  $scope.editButton = () ->
    if this.checked == true
      console.log("true")
      this.checked = false
      this.notice = "Edit"
    else
      console.log("setting true")
      this.checked = true
      this.notice = "Close"
      this.fadetask = false


  $scope.completeTodo = (task) ->
    console.log(task)
    if task.complete != 1
      task.complete = 1
      conf = confirm("Complete this task?")
      if conf

        $scope["completecheckbox" + task.id] = true

        
        $http.put("/todos/#{task.id}.json", task).success (data) ->


]

TodoApp.config ["$httpProvider", ($httpProvider)->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]