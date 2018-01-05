#
# Component generated by Impac! Widget Generator!
#
module = angular.module('impac.components.widgets.accounts-live-balance', [])
module.controller('WidgetAccountsLiveBalanceCtrl', ($scope, $q, ChartFormatterSvc, $filter) ->

  w = $scope.widget
  w.isLiveBalance = true

  # Define settings
  # --------------------------------------
  $scope.orgDeferred = $q.defer()
  $scope.accountBackDeferred = $q.defer()
  $scope.timePeriodDeferred = $q.defer()
  $scope.histModeDeferred = $q.defer()
  # $scope.chartDeferred = $q.defer()

  settingsPromises = [
    $scope.orgDeferred.promise
    $scope.accountBackDeferred.promise
    $scope.timePeriodDeferred.promise
    $scope.histModeDeferred.promise
    # $scope.chartDeferred.promise
  ]

  # Widget specific methods
  # --------------------------------------

  $scope.isDataFound=true
  w.initContext = ->
    $scope.isDataFound = w.content?

  $scope.getName = ->
    w.selectedAccount.name if w.selectedAccount?

  $scope.getTitle = ->
    w.content.table.table_title if w.content?

  $scope.getOpeningBalance = ->
    _.find(w.content.figure.metrics, (metric) ->
      metric.label == 'opening'
    ) if w.content?

  $scope.getClosingBalance = ->
    _.find(w.content.figure.metrics, (metric) ->
      metric.label == 'closing'
    ) if w.content?

  $scope.getCurrency = ->
    w.selectedAccount.currency if w.selectedAccount?

  $scope.getHeaders = ->
    w.content.table.table_headers if w.content?

  $scope.getTotal = ->
    summary = _.find(w.content.table.tables, (table) ->
      table.table_title == 'Bank Summary'
    ) if w.content?
    _.find(summary.table_rows, (row) ->
      name_match = if w.selectedAccount.name == 'All Accounts' then 'Total' else w.selectedAccount.name
      row.column_1 == name_match
    ) if w.selectedAccount?

  $scope.getStatementBalance = ->
    statement = _.find(w.content.table.tables, (table) ->
      table.table_title == 'Bank Statement'
    ) if w.content?
    _.find(statement.table_rows, (row) ->
      row.column_2 == "Closing Balance"
    ) if statement

  $scope.displayAccount = ->
    $scope.updateSettings(false).then ->
      w.format()

  # Needed for Kpis compatibility?
  # --------------------------------------
  $scope.kpiExtraParams = {}
  $scope.updateKpiExtraParams = (key, value)->
    $scope.kpiExtraParams[key] = angular.copy(value)

  # Chart formatting function
  # --------------------------------------
  $scope.drawTrigger = $q.defer()
  w.format = ->

  # Widget is ready: can trigger the "wait for settings to be ready"
  # --------------------------------------
  $scope.widgetDeferred.resolve(settingsPromises)
)
module.directive('widgetAccountsLiveBalance', ->
  return {
    restrict: 'A',
    controller: 'WidgetAccountsLiveBalanceCtrl'
  }
)
