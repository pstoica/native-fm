'use strict';

angular.module('nativeFM.controllers', []).
  controller('SendSongCtrl', [
    "$scope",
    "$http",
    function($scope, $http) {
      $scope.song = {
        url: "",
        location: "",
        tags: []
      };

      $scope.songPreview = null;
      $scope.tagEditor = {
        tag: ""
      };

      $scope.reset = function() {
        $scope.song = {
          url: "",
          location: "",
          tags: []
        };

        $scope.songPreview = null;
        $scope.tagEditor.tag = null;
      };

      $scope.tagFieldLength = function() {
        return Math.max($scope.tagEditor.tag.length, 10);
      };

      $scope.canAddTags = function() {
        if ($scope.songPreview) {
          return (($scope.songPreview.tags.length) +
            ($scope.song.tags.length)) >= 10;
        } else {
          return false;
        }
      };

      $scope.addTag = function($event) {
        console.log($scope.tagEditor.tag);
        $scope.song.tags.push($scope.tagEditor.tag);
        $scope.tagEditor.tag = "";
        $event.preventDefault();
      };

      $scope.removeTag = function(tag) {
        $scope.song.tags = _.without($scope.song.tags, tag);
      };

      $scope.submitSong = function() {
        $http.post('/transmissions', {
          song: $scope.song
        }).success(function(song) {
          $scope.reset();
        });
      };

      $scope.$watch('song.url', function(newUrl) {
        // FIXME: check if soundcloud or bandcamp
        if (_.isEmpty(newUrl)) {
          $scope.songPreview = undefined;
        } else {
          console.log(encodeURI(newUrl));
          $http.get('/songs/data', {
            params: {
              url: encodeURI(newUrl)
            }
          }).success(function(song) {
            $scope.songPreview = song;
          });
        }
      });
    }
  ]).
  controller('SettingsCtrl', [
    "$scope",
    "$http",
    function($scope, $http) {
      $scope.newTag = {
        name: ""
      };

      $http.get('/preferences').success(function(preferences) {
        $scope.preferences = preferences;
      });

      $scope.tagFieldLength = function() {
        return Math.max($scope.newTag.name.length, 10);
      };

      $scope.canAddTags = function() {
        if ($scope.preferences) {
          return $scope.preferences.length >= 10;
        } else {
          return false;
        }
      };

      $scope.addTag = function($event) {
        $http.post('/preferences', {tag: $scope.newTag}).success(function(preference) {
          $scope.preferences.push(preference);
          $scope.newTag = {
            name: ""
          };
        });
      };

      $scope.removePreference = function(preference) {
        $http.delete('/preferences/' + preference.id).success(function() {
          $scope.preferences = _.without($scope.preferences, preference);
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