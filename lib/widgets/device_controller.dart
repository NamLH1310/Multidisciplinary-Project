import 'package:flutter/material.dart';
import '../utils/global.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class DeviceSwitchList extends StatefulWidget {
  const DeviceSwitchList({Key? key}) : super(key: key);

  @override
  State<DeviceSwitchList> createState() => _DeviceSwitchListState();
}

class _DeviceSwitchListState extends State<DeviceSwitchList> {
  final Map<String, String> sensors = {};

  @override
  void initState() {
    firestore.collection("sensors").snapshots().listen(
      (event) {
        getSensors();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        sensorSwitchButton(
          collectionName: "sensors",
          documentName: "pump",
        ),
        sensorSwitchButton(
          collectionName: "sensors",
          documentName: "led",
        ),
      ],
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

  Widget sensorSwitchButton({
    required String collectionName,
    required String documentName,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(documentName.capitalize(),
              style: const TextStyle(fontSize: 18)),
        ),
        Center(
          child: Switch(
            value: sensors[documentName] == "ON",
            onChanged: (value) {
              firestore
                  .collection(collectionName)
                  .doc(documentName)
                  .update({"state": value ? "ON" : "OFF"});
              sensors[documentName] = value ? "ON" : "OFF";
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
