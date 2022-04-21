import 'package:flutter/material.dart';
import '../shared/menu_drawer.dart';
import '../widgets/graph.dart';

class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({Key? key}) : super(key: key);

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistics")),
      drawer: const MenuDrawer(),
      body: SingleChildScrollView(
        child: graphListColumn(),
      ),
    );
  }

  Widget graphListColumn() {
    return Column(
      children: [
        graphColumn(const GraphDisplay(
          dataUnit: "%",
          dataName: "Co2",
          collectionName: "co2_data",
        )),
        graphColumn(const GraphDisplay(
          dataUnit: "%",
          dataName: "Humid",
          collectionName: "humid_data",
        )),
        graphColumn(const GraphDisplay(
          dataUnit: "%",
          dataName: "Soil Moisture",
          collectionName: "soil_moisture_data",
        )),
        graphColumn(const GraphDisplay(
          dataUnit: "Celcius",
          dataName: "Temperature",
          collectionName: "temperature_data",
        )),
      ],
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
