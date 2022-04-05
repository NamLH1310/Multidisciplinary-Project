import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class GraphDisplay extends StatefulWidget {
  const GraphDisplay({Key? key, required this.nameType, required this.type})
      : super(key: key);
  final String nameType;
  final String type;
  @override
  State<GraphDisplay> createState() => _GraphDisplayState(nameType, type);
}

class _GraphDisplayState extends State<GraphDisplay> {
  late List<DataInput> _chartData;
  final String nameType;
  final String type;
  _GraphDisplayState(this.nameType, this.type);
  @override
  void initState() {
    _chartData = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
      body: SfCartesianChart(
        title: ChartTitle(text: type, alignment: ChartAlignment.center),
        series: <ChartSeries>[
          LineSeries<DataInput, double>(
            dataSource: _chartData,
            xValueMapper: (DataInput data, _) => data.number,
            yValueMapper: (DataInput data, _) => data.value,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
        primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.decimalPattern('en_us'),
            labelFormat: '{value} $nameType'),
        primaryXAxis: NumericAxis(isVisible: false),
      ),
    ));
  }

  List<DataInput> getData() {
    final List<DataInput> dataChart = [
      DataInput(35, 0),
      DataInput(40, 1),
      DataInput(25, 2)
    ];
    return dataChart;
  }
}

class DataInput {
  DataInput(this.value, this.number);
  final double value;
  final double number;
}
