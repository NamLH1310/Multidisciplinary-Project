import 'package:flutter/material.dart';
import '../shared/menu_drawer.dart';
import '../widgets/device_controller.dart';

class DeviceControllerScreen extends StatefulWidget {
  const DeviceControllerScreen({Key? key}) : super(key: key);

  @override
  State<DeviceControllerScreen> createState() => _DeviceControllerScreenState();
}

class _DeviceControllerScreenState extends State<DeviceControllerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Device Controller")),
      drawer: const MenuDrawer(),
      body: const DeviceSwitchList(),
    );
  }
}
