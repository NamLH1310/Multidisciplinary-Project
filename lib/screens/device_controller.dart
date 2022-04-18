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
  void initState() {
    getSensors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Device Controller")),
      drawer: const MenuDrawer(),
      body: Column(
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

// class SensorSwitchButton extends StatefulWidget {
//   final String collectionName;
//   final String documentName;
//   final String? state;
//   const SensorSwitchButton(
//       {Key? key,
//       this.collectionName = "",
//       this.documentName = "",
//       this.state = ""})
//       : super(key: key);

//   @override
//   State<SensorSwitchButton> createState() => _SensorSwitchButtonState();
// }

// class _SensorSwitchButtonState extends State<SensorSwitchButton> {
//   late bool currentState;
//   bool flag = true;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(widget.documentName.capitalize(),
//               style: const TextStyle(fontSize: 18)),
//         ),
//         Center(
//           child: Switch(
//             value: currentState,
//             onChanged: (value) {
//               firestore
//                   .collection(widget.collectionName)
//                   .doc(widget.documentName)
//                   .update({"state": value ? "ON" : "OFF"});
//               currentState = !currentState;
//               setState(() {});
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
