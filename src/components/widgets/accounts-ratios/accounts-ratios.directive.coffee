#
# Component generated by Impac! Widget Generator!
#
module = angular.module('impac.components.widgets.accounts-ratios', [])
module.controller('WidgetAccountsRatiosCtrl', ($scope, $q, $filter, ChartFormatterSvc, ImpacTheming) ->

  w = $scope.widget

  # Define settings
  # --------------------------------------
  $scope.orgDeferred = $q.defer()
  $scope.chartDeferred = $q.defer()
  $scope.timePeriodDeferred = $q.defer()
  $scope.histModeDeferred = $q.defer()
  $scope.numeratorOffsetsDeferred = $q.defer()
  $scope.denominatorOffsetsDeferred = $q.defer()

  settingsPromises = [
    $scope.orgDeferred.promise,
    $scope.chartDeferred.promise,
    $scope.timePeriodDeferred.promise,
    $scope.histModeDeferred.promise,
    $scope.numeratorOffsetsDeferred.promise,
    $scope.denominatorOffsetsDeferred.promise
  ]

  $scope.totalRatio = 0
  $scope.totalNumerator = 0
  $scope.totalDenominator = 0
  $scope.calculatedNumerator = 0
  $scope.calculatedDenominator = 0
  $scope.simulationMode = false
  $scope.intervalsCount = 0
  $scope.isPnl = false
  $scope.periodInfoContext = {}

  # Prefix for period indicator in simulation mode
  getPrefix = (behaviour) ->
    labels = ImpacTheming.get().widgetSettings.histModeChoser.currentLabels
    todayPrefixes = ImpacTheming.get().widgetSettings.histModeChoser.todayPrefixes

    needPrefix = (_.last(w.content.layout.dates) == moment().format('YYYY-MM-DD'))
    labelsArray = [labels[behaviour]]
    if needPrefix then labelsArray.unshift(todayPrefixes[behaviour])
    _.compact(labelsArray).join(' ')

  # Widget specific methods
  # --------------------------------------
  w.initContext = ->
    $scope.isDataFound = !_.isEmpty(w.content)
    if $scope.isDataFound
      $scope.intervalsCount = _.size(w.content.layout.dates)
      $scope.endDate = _.last(w.content.layout.dates)

      behaviour = w.content.layout.accounting_behaviour
      $scope.periodInfoContext.histParams = w.metadata.hist_parameters
      $scope.periodInfoContext.accountingBehaviour = behaviour
      $scope.periodInfoContext.injectBefore = getPrefix(behaviour)

      if behaviour == 'pnl'
        $scope.totalRatio = w.content.calculation.ratio.average
        $scope.totalNumerator = _.sum(w.content.calculation.numerator.totals)
        $scope.totalDenominator = _.sum(w.content.calculation.denominator.totals)
        $scope.calculatedNumerator = _.sum(w.content.calculation.numerator.values)
        $scope.calculatedDenominator = _.sum(w.content.calculation.denominator.values)
        $scope.isPnl = true
      else
        $scope.totalRatio = _.last(w.content.calculation.ratio.totals)
        $scope.totalNumerator = _.last(w.content.calculation.numerator.totals)
        $scope.totalDenominator = _.last(w.content.calculation.denominator.totals)
        $scope.calculatedNumerator = _.last(w.content.calculation.numerator.values)
        $scope.calculatedDenominator = _.last(w.content.calculation.denominator.values)

  $scope.toggleSimulationMode = (init = false)->
    $scope.initSettings() if init
    $scope.simulationMode = !$scope.simulationMode

  $scope.saveSimulation = ->
    $scope.updateSettings()
    $scope.toggleSimulationMode()


  # Chart formating function
  # --------------------------------------
  $scope.drawTrigger = $q.defer()
  # Format the widget content data for ChartJS.
  w.format = ->
    if $scope.isDataFound
      data = angular.copy(w.content)

      period = null
      period = w.metadata.hist_parameters.period if w.metadata? && w.metadata.hist_parameters?
      dates = _.map data.layout.dates, (date) ->
        $filter('mnoDate')(date, period)

      # inputData = {title: data.type, labels: dates, values: data.values}
      inputData = {labels: dates, datasets: [{title: data.layout.ratio, values: data.calculation.ratio.totals}]}
      options = { currency: 'hide' }

      chartData = ChartFormatterSvc.combinedBarChart(inputData, options, false)
      
      # calls chart.draw()
      $scope.drawTrigger.notify(chartData)
  

  # Widget is ready: can trigger the "wait for settings to be ready"
  # --------------------------------------
  $scope.widgetDeferred.resolve(settingsPromises)
)
module.directive('widgetAccountsRatios', ->
  return {
    restrict: 'A',
    controller: 'WidgetAccountsRatiosCtrl'
  }
)
