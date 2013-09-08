'use strict';

angular.module('nativeFM.controllers', []).
  controller('SendSongCtrl', [
    "$scope",
    "$http",
    "$rootScope",
    "$timeout",
    function($scope, $http, $rootScope, $timeout) {
      $scope.song = {
        url: "",
        location: "",
        tags: []
      };

      $scope.searchResults = [];
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
          $rootScope.$broadcast('newSong', song);
          $scope.reset();
        });
      };

      $scope.$on('reshare', function(event, songUrl) {
        console.log(event);
        $scope.song.url = songUrl;
      });

      $scope.addSearchResult = function(url) {
        $scope.song.url = url;
      };

      $scope.searchTimeout = null;

      $scope.$watch('song.url', function(newUrl) {
        if ($scope.searchTimeout) {
          $timeout.cancel($scope.searchTimeout);
        }

        $scope.searchTimeout = $timeout(function() {
          $scope.updateResults(newUrl);
        }, 500);
      });

      $scope.updateResults = function(newUrl) {
        if (_.isEmpty(newUrl)) {
          $scope.songPreview = undefined;
          $scope.searchResults = [];
        } else {
          if (/https?:\/\/soundcloud.com\/[\w\-]*\/.*/.test(newUrl) ||
          /https?:\/\/.+\.bandcamp.com\/track\/.+/.test(newUrl)) {
            $http.get('/songs/data', {
              params: {
                url: encodeURI(newUrl)
              }
            }).success(function(song) {
              $scope.songPreview = song;
              $scope.searchResults = []
            });
          } else {
            $http.get('/songs/search', {
              params: {
                q: newUrl
              }
            }).success(function(searchResults) {
              $scope.searchResults = searchResults;
            });
          }
        }
      }
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
    "$sce",
    "$timeout",
    "$rootScope",
    function($scope, $http, $sce, $timeout, $rootScope) {
      // Get your data here
      $scope.updateInbox = function() {
        console.log("UPDATING INBOX");
        $http.get("/songs/received").
        success(function(data, status, headers, config) {
          $scope.inbox = data;
          $scope.updateBounds();
          $timeout(function() {
            $scope.updateInbox();
          }, 8000);
        }).
        error(function(data, status, headers, config) {
          $scope.error = "We couldn't load the received songs";
          $timeout(function() {
            $scope.updateInbox();
          }, 5000);
        });
      };

      $scope.updateInbox();

      $scope.mapOptions = {
        mapTypeControlOptions: {
          mapTypeIds: [google.maps.MapTypeId.ROADMAP]
        },
        streetViewControl: false,
        zoom: 5
      };

      $scope.markerOptions = {
        icon: '/assets/marker.png'
      };

      $scope.mapBounds = new google.maps.LatLngBounds();

      $scope.reshare = function(songUrl) {
        $rootScope.$broadcast('reshare', songUrl);
      };

      $scope.updateBounds = function() {
        var bounds = new google.maps.LatLngBounds();

        angular.forEach($scope.inbox, function(item) {
          bounds.extend(new google.maps.LatLng(item.song.lat, item.song.long));
        });
        $scope.mapBounds = bounds;
      };

      $scope.embedCode = function(transmission) {
        var embed;

        // FIXME: what the fuck am i doing here, is this 1999
        if (transmission.song.soundcloud_id) {
          embed = '<iframe width="100%" height="166" scrolling="no" frameborder="no" src="' +
            'https://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F' +
            transmission.song.soundcloud_id +
            '&amp;color=e86243&amp;auto_play=false&amp;show_artwork=true&amp;show_comments=false"></iframe>';
        } else if (transmission.song.bandcamp_album_id) {
          embed = '<iframe style="border: 0; width: 100%; height: 120px;" src="http://bandcamp.com/EmbeddedPlayer/album=' +
            transmission.song.bandcamp_album_id +
            '/size=medium/bgcol=ffffff/linkcol=e86243/transparent=true/t=' +
            transmission.song.bandcamp_track_number +
            '/" seamless></iframe>';
        }

        return $sce.trustAsHtml(embed);
      };
    }
  ]).
  controller('SentSongsCtrl', [
    "$scope",
    "$http",
    "$rootScope",
    function($scope, $http, $rootScope) {

      $scope.updateSent = function() {
        $http.get("/songs/sent").
        success(function(data, status, headers, config) {
          $scope.sent = data;
        }).
        error(function(data, status, headers, config) {
          $scope.error = "We couldn't load the sent songs";
        }); 
      }

      $rootScope.$on('newSong', function(event) {
        $scope.updateSent();
      });

      $scope.updateSent();
    }
  ]);