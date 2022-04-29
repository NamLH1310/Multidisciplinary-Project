import 'package:flutter/material.dart';
import 'package:multidisciplinary_project_se/widgets/notification.dart';
import '../widgets/device_controller.dart';
import '../widgets/graph.dart';
import '../widgets/device_progress_bar.dart';

class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({Key? key}) : super(key: key);

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Garden"),
        actions: const [
          DashBoardNotification(),
        ],
      ),
      body: SingleChildScrollView(
        child: dashBoard(),
      ),
    );
  }

  Widget dashBoard() {
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
            child: Wrap(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 32.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 30, 194, 235),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: size.height / 5.0,
                    child: const DeviceSwitchList(),
                  ),
                ),
                const DeviceProgressBar(
                  thresholds: [50, 70],
                  collectionName: "temperature_data",
                  deviceName: "Temperature",
                  unit: "\u2103",
                ),
                const DeviceProgressBar(
                  thresholds: [50, 70],
                  collectionName: "humid_data",
                  deviceName: "Humid",
                ),
                const DeviceProgressBar(
                  thresholds: [280, 290],
                  min: 0,
                  max: 300,
                  collectionName: "soil_moisture_data",
                  deviceName: "Soil moisture",
                ),
                const DeviceProgressBar(
                  thresholds: [400, 700],
                  min: 0,
                  max: 1000,
                  collectionName: "co2_data",
                  unit: "ppm",
                  deviceName: "Co2",
                ),
              ],
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
