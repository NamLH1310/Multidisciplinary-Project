import 'package:flutter/material.dart';
import '../widgets/graph.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Garden")),
      body: Column(
        children: [
          graphColumn(const GraphDisplay(
            dataUnit: "%",
            dataName: "Co2",
            collectionName: "co2_data",
          )),
        ],
      ),
    );
  }

  Widget graphColumn(GraphDisplay graph) {
    Size size = MediaQuery.of(context).size;
    Widget column = Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: size.width,
        height: size.height / 3.0,
        child: graph,
      ),
    );
    return column;
  }
}
