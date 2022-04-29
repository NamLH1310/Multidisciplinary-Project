import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../data/helper.dart';
import '../utils/global.dart';

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
  final _chartData = LinkedList<DataInput>();

  @override
  void initState() {
    checkForChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
        text: widget.dataName,
        alignment: ChartAlignment.center,
      ),
      series: <ChartSeries>[
        LineSeries<DataInput, double>(
          dataSource: _chartData.toList(),
          xValueMapper: (DataInput data, _) => data.x,
          yValueMapper: (DataInput data, _) => data.y,
        )
      ],
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.decimalPattern('en_us'),
        labelFormat: '{value}',
        title: AxisTitle(text: "${widget.dataName} (${widget.dataUnit})"),
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
      var datas = await CollectionRef(widget.collectionName).getData(limit: 20);
      _chartData.clear();
      _chartData.addAll(datas);
      setState(() {});
    } catch (error) {
      debugPrint("$error");
    }
  }

  checkForChanges() {
    firestore.collection(widget.collectionName).snapshots().listen(
      (event) async {
        debugPrint("${widget.collectionName} has changed");
        getData();
        // final latestData =
        //     await CollectionRef(widget.collectionName).getLatestData();
        // _chartData.remove(_chartData.last);
        // _chartData.addFirst(latestData);
        setState(() {});
      },
    );
  }
}
