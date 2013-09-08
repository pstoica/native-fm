'use strict';

angular.module('nativeFM.controllers', []).
  controller('SendSongCtrl', [
    $scope,
    $http,
    function($scope, $http) {

    }
  ]).
  controller('SettingsCtrl', [
    $scope,
    $http,
    function($scope, $http) {

    }
  ]).
  controller('InboxCtrl', [
    "$scope",
    "$http",
    function($scope, $http) {
      // Get your data here
      $http.get("/songs/received").
      success(function(data, status, headers, config) {
        $scope.inbox = data;
      }).
      error(function(data, status, headers, config) {
        $scope.error = "We couldn't load the received songs";
      });
      
    }
  ]).
  controller('SentSongsCtrl', [
    "$scope",
    "$http",
    function($scope, $http) {

    }
  ]);