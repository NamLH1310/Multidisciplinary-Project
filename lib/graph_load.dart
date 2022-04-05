import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';


//them vai attr de lay data tu web ve
class graphDisplay extends StatefulWidget {
  graphDisplay({Key? key, required this.name_type,required this.type}) : super(key: key);
  final String name_type;
  final String type;
  @override
  State<graphDisplay> createState() => _graphDisplayState(name_type,type);
}

class _graphDisplayState extends State<graphDisplay> {
  late List<dataInput> _chartData;
  final String name_type;
  final String type;
  _graphDisplayState(this.name_type,this.type);
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
        title: ChartTitle(text: type,alignment: ChartAlignment.center),
        series: <ChartSeries>[
          LineSeries<dataInput, double>(
            dataSource: _chartData,
            xValueMapper: (dataInput data, _) => data.number,
            yValueMapper: (dataInput data, _) => data.value,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          )
        ],
        primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.decimalPattern('en_us'),
            labelFormat: '{value} ${name_type}'),
        primaryXAxis: NumericAxis(isVisible: false),
      ),
    ));
  }

  List<dataInput> getData() {
    final List<dataInput> dataChart = [
      dataInput(35, 0),
      dataInput(40, 1),
      dataInput(25, 2)
    ];
    return dataChart;
  }
}

class dataInput {
  dataInput(this.value, this.number);
  final double value;
  final double number;
}
