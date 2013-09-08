'use strict';

angular.module('nativeFM.controllers', []).
  controller('SendSongCtrl', [
    '$scope',
    '$http',
    function($scope, $http) {
      $scope.newTag = {
        name: ""
      };

      $scope.tagFieldLength = function() {
        return Math.max($scope.newTag.name.length, 10);
      };

      $scope.addTag = function($event) {

      };

      $scope.removeTag = function(tag) {

      };
    }
  ]).
  controller('SettingsCtrl', [
    '$scope',
    '$http',
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
      }

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
    '$scope',
    '$http',
    function($scope, $http) {

    }
  ]).
  controller('SentSongsCtrl', [
    '$scope',
    '$http',
    function($scope, $http) {

    }
  ]);