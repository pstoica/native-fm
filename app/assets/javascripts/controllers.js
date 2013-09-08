'use strict';

angular.module('nativeFM.controllers', []).
  controller('SendSongCtrl', [
    "$scope",
    "$http",
    function($scope, $http) {
      $scope.newTag = {
        name: ""
      };

      $scope.tagFieldLength = function() {
        return Math.max($scope.newTag.name.length, 10);
      };

      $scope.canAddTags = function() {
        if ($scope.song) {
          return $scope.song.tags.length >= 10;
        } else {
          return false;
        }
      };

      $scope.addTag = function($event) {

      };

      $scope.removeTag = function(tag) {
        $http.delete('/tags/' + tag.id).success(function() {
          $scope.tags = _.without($scope.tags, tag);
        });
      };
    }
  ]).
  controller('SettingsCtrl', [
    "$scope",
    "$http",
    function($scope, $http) {
      $scope.newTag = {
        name: ""
      };

      $http.get('/tags').success(function(tags) {
        $scope.tags = tags;
      });

      $scope.tagFieldLength = function() {
        return Math.max($scope.newTag.name.length, 10);
      };

      $scope.canAddTags = function() {
        if ($scope.tags) {
          return $scope.tags.length >= 10;
        } else {
          return false;
        }
      };

      $scope.addTag = function($event) {
        $http.post('/tags', {tag: $scope.newTag}).success(function(tag) {
          $scope.tags.push(tag);
          $scope.newTag = {
            name: ""
          };
        });
      };

      $scope.removeTag = function(tag) {
        $http.delete('/tags/' + tag.id).success(function() {
          $scope.tags = _.without($scope.tags, tag);
        });
      };
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
      $http.get("/songs/sent").
      success(function(data, status, headers, config) {
        $scope.sent = data;
      }).
      error(function(data, status, headers, config) {
        $scope.error = "We couldn't load the sent songs";
      });
    }
  ]);