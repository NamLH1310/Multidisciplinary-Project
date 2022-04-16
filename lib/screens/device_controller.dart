import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../shared/menu_drawer.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class DeviceController extends StatefulWidget {
  const DeviceController({Key? key}) : super(key: key);

  @override
  State<DeviceController> createState() => _DeviceControllerState();
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class _DeviceControllerState extends State<DeviceController> {
  final Map<String, String> sensors = {};

  @override
  Widget build(BuildContext context) {
    getSensors();
    return Scaffold(
      appBar: AppBar(title: const Text("Device Controller")),
      drawer: const MenuDrawer(),
      body: Column(
        children: <Widget>[
          SensorSwitchButton(
            collectionName: "sensors",
            documentName: "pump",
            state: sensors["pump"],
          ),
          SensorSwitchButton(
            collectionName: "sensors",
            documentName: "led",
            state: sensors["led"],
          ),
        ],
      ),
    );
  }

  Future<void> getSensors() async {
    final collectionRef = firestore.collection("sensors");
    final docSnapshots = await collectionRef.get();
    for (var doc in docSnapshots.docs) {
      sensors[doc.id] = doc.data()["state"];
    }
    setState(() {});
  }
}

class SensorSwitchButton extends StatefulWidget {
  final String collectionName;
  final String documentName;
  final String? state;
  const SensorSwitchButton(
      {Key? key,
      this.collectionName = "",
      this.documentName = "",
      this.state = ""})
      : super(key: key);

  @override
  State<SensorSwitchButton> createState() => _SensorSwitchButtonState();
}

class _SensorSwitchButtonState extends State<SensorSwitchButton> {
  @override
  Widget build(BuildContext context) {
    bool currentState = (widget.state == "ON");
    return Row(
      children: <Widget>[
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.documentName.capitalize(),
                style: const TextStyle(fontSize: 18)),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Switch(
              value: currentState,
              onChanged: (value) {
                firestore
                    .collection(widget.collectionName)
                    .doc(widget.documentName)
                    .update({"state": value ? "ON" : "OFF"});
                currentState = value;
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }
}
