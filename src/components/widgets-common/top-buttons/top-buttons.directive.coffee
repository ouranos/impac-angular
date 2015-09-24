module = angular.module('impac.components.widgets-common.top-buttons', [])
module.controller('CommonTopButtonsCtrl', ($scope, $rootScope, $log, DhbAnalyticsSvc, ImpacAssets) ->

  w = $scope.parentWidget

  $scope.showCloseActive = false
  $scope.showEditActive = false
  $scope.showConfirmDelete = false

  w.isEditMode = false

  $scope.deleteWidget = ->
    DhbAnalyticsSvc
      .widgets
      .delete(w.id, w.parentDashboard)
      .then( () ->
        $log.debug('Successfully removed widget!')
      ,(errors) ->
        w.errors = Utilities.processRailsError(errors)
        $log.error('Error deleting widget: ', errors)
      )
    # Refresh needed to display the 'add a widget' message in case of no widget
    # ).finally(-> DhbAnalyticsSvc.load(true))

  $scope.toogleEditMode = ->
    if !w.isLoading
      if w.isEditMode
        # Like a press on 'Cancel' button
        w.initSettings()
      else
        # Otherwise, we pass in edit mode
        w.isEditMode = true
)

module.directive('commonTopButtons', ($templateCache) ->
  return {
    restrict: 'A',
    scope: {
      parentWidget: '='
    },
    template: $templateCache.get('widgets-common/top-buttons.tmpl.html'),
    controller: 'CommonTopButtonsCtrl'
  }
)