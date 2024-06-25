import 'package:flutter/material.dart';
import 'package:flutter_front/screens/ExamTension/TensionApi.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartComponent extends StatelessWidget {
  final List<SalesData> chartData;
  final List<SalesData> chartData1;
  final TooltipBehavior tooltipBehavior;

  ChartComponent({
    required this.chartData,
    required this.chartData1,
    required this.tooltipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        tooltipBehavior: tooltipBehavior,
        series: <CartesianSeries>[
          LineSeries<SalesData, String>(
            dataSource: chartData,
            xValueMapper: (SalesData sales, _) =>
                '${sales.dateTime.month}/${sales.dateTime.day} ${sales.dateTime.hour}:${sales.dateTime.minute}',
            yValueMapper: (SalesData sales, _) => sales.sales,
            name: 'Systolic Pressure',
            enableTooltip: true,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
            ),
          ),
          LineSeries<SalesData, String>(
            dataSource: chartData1,
            xValueMapper: (SalesData sales, _) =>
                '${sales.dateTime.month}/${sales.dateTime.day} ${sales.dateTime.hour}:${sales.dateTime.minute}',
            yValueMapper: (SalesData sales, _) => sales.sales,
            name: 'Diastolic Pressure',
            enableTooltip: true,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
            ),
          ),
        ],
      ),
    );
  }
}


