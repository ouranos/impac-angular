module = angular.module('impac.components.widgets.sales-list',[])

module.controller('WidgetSalesListCtrl', ($scope, $q, ChartFormatterSvc, ImpacWidgetsSvc) ->

  w = $scope.widget

  # Define settings
  # --------------------------------------
  $scope.orgDeferred = $q.defer()
  $scope.paramSelectorDeferred1 = $q.defer()
  $scope.paramSelectorDeferred2 = $q.defer()

  settingsPromises = [
    $scope.orgDeferred.promise
    $scope.paramSelectorDeferred1.promise
    $scope.paramSelectorDeferred2.promise
  ]


  # Widget specific methods
  # --------------------------------------
  w.initContext = ->
    if $scope.isDataFound = angular.isDefined(w.content) && !_.isEmpty(w.content.summary)

      $scope.periodOptions = [
        {label: 'year', value: 'YEARLY'},
        {label: 'quarter', value: 'QUARTERLY'},
        {label: 'month', value: 'MONTHLY'},
        {label: 'week', value: 'WEEKLY'},
        {label: 'day', value: 'DAILY'},
      ]
      $scope.period = angular.copy(_.find($scope.periodOptions, (o) ->
        o.value == w.content.hist_parameters.period
      ) || $scope.periodOptions[0])

      $scope.filterOptions = [
        {label: 'value sold (incl. taxes)', value: 'gross_value_sold'},
        {label: 'value sold (excl. taxes)', value: 'net_value_sold'},
        {label: 'quantity sold', value: 'quantity_sold'},
        {label: 'value purchased (incl. taxes)', value: 'gross_value_purchased'},
        {label: 'value purchased (excl. taxes)', value: 'net_value_purchased'},
        {label: 'quantity purchased', value: 'quantity_purchased'},
      ]
      $scope.filter = angular.copy(_.find($scope.filterOptions, (o) ->
        o.value == w.content.filter
      ) || $scope.filterOptions[0])

      $scope.unCollapsed = w.metadata.unCollapsed || []

  $scope.toggleCollapsed = (categoryName) ->
    if categoryName?
      if _.find($scope.unCollapsed, ((name) -> categoryName == name))
        $scope.unCollapsed = _.reject($scope.unCollapsed, (name) ->
          name == categoryName
        )
      else
        $scope.unCollapsed.push(categoryName)
      ImpacWidgetsSvc.updateWidgetSettings(w,false)

  $scope.isCollapsed = (categoryName) ->
    if categoryName?
      if _.find($scope.unCollapsed, ((name) -> categoryName == name))
        return false
      else
        return true


  # Mini-settings
  # --------------------------------------
  unCollapsedSetting = {}
  unCollapsedSetting.initialized = false

  unCollapsedSetting.initialize = ->
    unCollapsedSetting.initialized = true

  unCollapsedSetting.toMetadata = ->
    {unCollapsed: $scope.unCollapsed}

  w.settings.push(unCollapsedSetting)


  # Widget is ready: can trigger the "wait for settigns to be ready"
  # --------------------------------------
  $scope.widgetDeferred.resolve(settingsPromises)
)

module.directive('widgetSalesList', ->
  return {
    restrict: 'A',
    controller: 'WidgetSalesListCtrl'
  }
)