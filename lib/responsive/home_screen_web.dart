import 'package:flutter/material.dart';
import '../widgets/device_controller.dart';
import '../widgets/graph.dart';

class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({Key? key}) : super(key: key);

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Garden")),
      body: SingleChildScrollView(
        child: graphListColumn(),
      ),
    );
  }

  Widget graphListColumn() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(right: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Wrap(
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
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(top: 32.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 30, 194, 235),
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
              child: SizedBox(
                height: size.height / 3.0,
                child: const DeviceSwitchList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget graphColumn(GraphDisplay graph) {
    Size size = MediaQuery.of(context).size;
    Widget column = Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: size.width / 3.0,
        height: size.height / 3.0,
        child: graph,
      ),
    );
    return column;
  }
}
