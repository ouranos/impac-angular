module = angular.module('impac.components.widgets-settings.width',[])

module.controller('SettingWidthCtrl', ($scope, $log, ImpacWidgetsSvc) ->

  w = $scope.parentWidget

  w.toggleExpanded = ->
    $scope.expanded = !$scope.expanded
    # false because we want to resize the widget without waiting for the response from the dashboarding API
    ImpacWidgetsSvc.updateWidgetSettings(w,false)
    
    if $scope.expanded
      w.width = parseInt($scope.max)
    else
      w.width = parseInt($scope.min)

  # What will be passed to parentWidget
  setting = {}
  setting.key = "width"
  setting.isInitialized = false

  w.isExpanded = ->
    $scope.expanded

  # initialization of time range parameters from widget.content.hist_parameters
  setting.initialize = ->
    if w.width?
      $scope.expanded = (w.width == parseInt($scope.max))
      setting.isInitialized = true

  setting.toMetadata = ->
    if $scope.expanded
      newWidth = $scope.max
    else
      newWidth = $scope.min
    return { width: parseInt(newWidth) }

  w.settings.push(setting)

  # Setting is ready: trigger load content
  # ------------------------------------
  $scope.deferred.resolve($scope.parentWidget)
)

module.directive('settingWidth', ($templateCache) ->
  return {
    restrict: 'A',
    scope: {
      parentWidget: '=',
      deferred: '='
      min: '@',
      max: '@',
    },
    template: $templateCache.get('widgets-settings/width.tmpl.html'),
    controller: 'SettingWidthCtrl'
  }
)
