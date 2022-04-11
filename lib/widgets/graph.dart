import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../data/helper.dart';

class GraphDisplay extends StatefulWidget {
  final String dataUnit;
  final String dataName;
  final String collectionName;
  const GraphDisplay(
      {Key? key,
      required this.dataUnit,
      required this.dataName,
      required this.collectionName})
      : super(key: key);
  @override
  State<GraphDisplay> createState() => _GraphDisplayState();
}

class _GraphDisplayState extends State<GraphDisplay> {
  _GraphDisplayState() : super();

  List<DataInput> _chartData = [];

  @override
  Widget build(BuildContext context) {
    getData();
    return SfCartesianChart(
      title: ChartTitle(
        text: widget.dataName,
        alignment: ChartAlignment.center,
      ),
      series: <ChartSeries>[
        LineSeries<DataInput, double>(
          dataSource: _chartData,
          xValueMapper: (DataInput data, _) => data.x,
          yValueMapper: (DataInput data, _) => data.y,
        )
      ],
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.decimalPattern('en_us'),
        labelFormat: '{value}',
        title: AxisTitle(text: "Co2 value (${widget.dataUnit})"),
      ),
      primaryXAxis: NumericAxis(
        numberFormat: NumberFormat.decimalPattern('en_us'),
        labelFormat: '{value}',
        title: AxisTitle(text: "Time (s)"),
      ),
    );
  }

  getData() async {
    try {
      _chartData =
          await CollectionRef(widget.collectionName, limit: 20).getData();
      setState(() {});
    } catch (error) {
      debugPrint("$error");
    }
  }
}
