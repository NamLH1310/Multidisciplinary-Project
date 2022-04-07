import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final co2DataRef = firestore.collection("co2_data");

  List<Map<String, dynamic>> m = [];

  Future<void> getData() async {
    try {
      var datas = await co2DataRef.limit(10).get();
      for (var doc in datas.docs) {
        m.add(doc.data());
      }
      // setState(() {});
      debugPrint('$m');
    } catch (error) {
      debugPrint("$error");
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartHouse'),
      ),
      body: Center(
        child: Text('$m'),
      ),
    );
  }
}
