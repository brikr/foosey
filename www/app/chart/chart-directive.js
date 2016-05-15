(function()
{
  angular
    .module('chart', [])
    .directive('chart', chart);

  function chart()
  {
    return {
      restrict: 'E',
      templateUrl: 'app/chart/chart.html',
      scope: { options: '=' },
      controller: controller
    }
  }

  controller.$inject = ['$scope', '$timeout'];

  function controller($scope, $timeout)
  {
    // Set up the chart
    $timeout(function() {
      $('#' + $scope.options.class).highcharts({
        chart: {
          type: 'spline'      
        },
        title: {
          text: $scope.options.title
        },
        subtitle: {
          text: $scope.options.subtitle
        },
        xAxis: {
          categories: $scope.options.dates
        },
        yAxis: {
          title: {
            text: $scope.options.yAxis
          }
        },
          legend: {
            enabled: false
          },
          plotOptions: {
            line: {
              dataLabels: {
                enabled: true
              },
              enableMouseTracking: false
            }
          },
        plotOptions: {
          spline: {
            marker: {
              radius: 4,
              lineColor: '#666666',
              lineWidth: 1
            }
          }
        },
        series: [{
          name: $scope.options.yAxis,
          marker: {
            symbol: 'diamond'
          },
          data: $scope.options.data
        }]
      });

      // Remove link
      $("text")[$("text").length -1].remove();
    });
  }
})();