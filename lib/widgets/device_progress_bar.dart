import 'dart:async';
import 'dart:core';
import 'package:multidisciplinary_project_se/utils/global.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import '../data/helper.dart';

class DeviceProgressBar extends StatefulWidget {
  final String? deviceName;
  final String collectionName;
  final String? unit;
  final double? min;
  final double? max;
  final List<double>? thresholds;
  const DeviceProgressBar(
      {Key? key,
      this.min,
      this.max,
      this.thresholds,
      required this.collectionName,
      this.deviceName,
      this.unit})
      : super(key: key);

  @override
  State<DeviceProgressBar> createState() => _DeviceProgressBarState();
}

class _DeviceProgressBarState extends State<DeviceProgressBar> {
  double progressValue = 0.0;
  Color pointerColor = Colors.lightBlue;
  late Timer _timer;

  @override
  void initState() {
    progressValueListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 300,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.purpleAccent,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: SfRadialGauge(
        title: GaugeTitle(
            text: (widget.deviceName ?? widget.collectionName) +
                " (${widget.unit ?? '%'})",
            textStyle: const TextStyle(
              fontSize: 20,
            )),
        axes: <RadialAxis>[
          RadialAxis(
            minimum: widget.min ?? 0,
            maximum: widget.max ?? 100,
            radiusFactor: 0.85,
            showLabels: false,
            showTicks: false,
            axisLineStyle: const AxisLineStyle(
              color: Color.fromARGB(30, 0, 169, 181),
              cornerStyle: CornerStyle.bothCurve,
              thickness: 0.2,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <RangePointer>[
              RangePointer(
                color: pointerColor,
                value: progressValue,
                cornerStyle: CornerStyle.bothCurve,
                width: 0.2,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 100,
                animationType: AnimationType.linear,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                positionFactor: 0.1,
                angle: 90,
                widget: Text(
                  "$progressValue",
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  progressValueListener() {
    startTimer();
    firestore.collection(widget.collectionName).snapshots().listen((event) {
      _timer.cancel();
      getProgressValue();
      startTimer();
    });
  }

  startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      debugPrint("${widget.collectionName}: Timer cancel");
      firestore.collection("notifications").add({
        "message": widget.collectionName + " has stop working",
        "createAt": DateTime.now(),
      });
      timer.cancel();
    });
  }

  Future<void> getProgressValue() async {
    try {
      final value = await CollectionRef(widget.collectionName).getLatestData();
      progressValue = value.y;
      pointerColor = getColor();
      setState(() {});
    } catch (error) {
      debugPrint("$error");
    }
  }

  Color getColor() {
    if (widget.thresholds == null) {
      return Colors.lightBlue;
    }
    if (progressValue <= widget.thresholds![0]) {
      return Colors.lightBlue;
    } else if (progressValue <= widget.thresholds![1]) {
      return Colors.orange;
    }
    return Colors.redAccent;
  }
}
