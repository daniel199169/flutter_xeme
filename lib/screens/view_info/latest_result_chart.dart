import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LatestResultChart extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  LatestResultChart({Key key}) : super(key: key);

  @override
  _LatestResultChartState createState() => _LatestResultChartState();
}

class _LatestResultChartState extends State<LatestResultChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: SfCartesianChart(
              borderColor: Colors.black,
              borderWidth: 0,
              backgroundColor: Colors.black,
              plotAreaBorderColor: Colors.black,
              zoomPanBehavior: ZoomPanBehavior(enablePanning: true),
              primaryXAxis: DateTimeAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  intervalType: DateTimeIntervalType.days,
                  interval: 1,
                  dateFormat: DateFormat.yMMM(),
                  majorGridLines: MajorGridLines(
                    color: Colors.transparent,
                  ),
                  labelRotation: -90),
              primaryYAxis: NumericAxis(
                labelStyle: ChartTextStyle(color: Colors.grey),
                majorGridLines: MajorGridLines(
                  color: Colors.transparent,
                ),
              ),
              series: getRandomData()),
        ),
      ),
    );
  }

  static List<StackedLineSeries<ChartSampleData, DateTime>> getRandomData() {
    final dynamic chartData = <ChartSampleData>[
      ChartSampleData(DateTime(2017, 9, 25), 10, 11, 13, 15),
      ChartSampleData(DateTime(2017, 9, 26), 20, 45, 24, 11),
      ChartSampleData(DateTime(2017, 9, 27), 40, 14, 24, 34),
      ChartSampleData(DateTime(2017, 9, 28), 60, 35, 32, 31),
      ChartSampleData(DateTime(2017, 9, 29), 45, 32, 21, 5),
      ChartSampleData(DateTime(2017, 9, 30), 50, 45, 23, 11),
      ChartSampleData(DateTime(2017, 10, 01), 38, 11, 12, 14),
      ChartSampleData(DateTime(2017, 10, 02), 33, 23, 25, 28),
      ChartSampleData(DateTime(2017, 10, 03), 27, 34, 45, 12),
      ChartSampleData(DateTime(2017, 10, 04), 31, 22, 24, 25),
      ChartSampleData(DateTime(2017, 10, 05), 23, 18, 24, 31)
    ];
    return <StackedLineSeries<ChartSampleData, DateTime>>[
      StackedLineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        color: Colors.green,
        xValueMapper: (ChartSampleData sales, _) => sales.year,
        yValueMapper: (ChartSampleData sales, _) => sales.sales,
        name: 'Views',
        //legendItemText: 'dddddd',
      ),
      StackedLineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        color: Color(0xFF2B8DD8),
        xValueMapper: (ChartSampleData sales, _) => sales.year,
        yValueMapper: (ChartSampleData sales, _) => sales.sales2 - 11,
        name: 'Commented',
        //legendItemText: 'dddddd',
      ),
      StackedLineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        color: Colors.purple,
        xValueMapper: (ChartSampleData sales, _) => sales.year,
        yValueMapper: (ChartSampleData sales, _) => sales.sales3 - 13,
        name: 'Added to their list',
        //legendItemText: 'dddddd',
      ),
      StackedLineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        color: Colors.lightBlueAccent,
        xValueMapper: (ChartSampleData sales, _) => sales.year,
        yValueMapper: (ChartSampleData sales, _) => sales.sales4 - 15,
        name: 'Responses',
        //legendItemText: 'dddddd',
      ),
    ];
  }
}

class ChartSampleData {
  ChartSampleData(this.year, this.sales, this.sales2, this.sales3, this.sales4);

  final DateTime year;
  final int sales;
  final int sales2;
  final int sales3;
  final int sales4;
}
