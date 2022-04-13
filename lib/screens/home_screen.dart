import 'package:flutter/material.dart';
import '../widgets/graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:rolling_switch/rolling_switch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool status = false;
  bool status2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Garden")),
      body: Column(
        children: [
          Row(children: [
            Expanded(
                child: graphColumn(const GraphDisplay(
              dataUnit: "%",
              dataName: "Co2",
              collectionName: "co2_data",
            ))),
            Expanded(
                child: graphColumn(const GraphDisplay(
              dataUnit: "%",
              dataName: "Temprerature",
              collectionName: "temperature_data",
            ))),
            Expanded(
                child: textBox(const SizedBox(
              child: Card(child: Text('Hello World!')),
            )))
          ]),
          Row(
            children: [
              Expanded(
                  child: graphColumn(const GraphDisplay(
                dataUnit: "%",
                dataName: "Co2",
                collectionName: "co2_data",
              ))),
              Expanded(
                  child: graphColumn(const GraphDisplay(
                dataUnit: "%",
                dataName: "Temprerature",
                collectionName: "temperature_data",
              ))),
              Expanded(
                  child: Stack(children: <Widget>[
                Align(
                    alignment: Alignment.centerRight,
                    child: RollingSwitch.icon(
                        innerSize: 40,
                        onChanged: (bool state) {
                          // print('turned ${(state) ? 'on' : 'off'}');
                        },
                        rollingInfoLeft: const RollingIconInfo(
                            text: Text("Off"),
                            backgroundColor: Colors.redAccent,
                            icon: Icons.lightbulb_outline_rounded),
                        rollingInfoRight: const RollingIconInfo(
                            text: Text("On"),
                            backgroundColor: Colors.greenAccent,
                            icon: Icons.lightbulb_outline_rounded))),
                Align(
                    alignment: Alignment.center,
                    child: RollingSwitch.icon(
                      innerSize: 40,
                      onChanged: (bool state) {
                        // print('turned ${(state) ? 'on' : 'off'}');
                      },
                      rollingInfoLeft: const RollingIconInfo(
                          text: Text("Off"),
                          backgroundColor: Colors.redAccent,
                          icon: Icons.close),
                      rollingInfoRight: const RollingIconInfo(
                          text: Text("On"),
                          backgroundColor: Colors.greenAccent),
                    ))
              ]))
            ],
          )
        ],
      ),
    );
  }

  Widget buildIOSSwitch() => Transform.scale(
        scale: 1.5,
        child: CupertinoSwitch(
          value: status,
          onChanged: (value) => setState(() => status = value),
        ),
      );

  Widget graphColumn(GraphDisplay graph) {
    // Size size = MediaQuery.of(context).size;
    Widget column = Expanded(
      // padding: const EdgeInsets.all(8.0),
      // flex: 2,
      child: SizedBox(
        width: 200.0,
        height: 300.0,
        child: graph,
      ),
    );
    return column;
  }

  Widget textBox(SizedBox box) {
    // Size size = MediaQuery.of(context).size;
    Widget column = Expanded(
      // padding: const EdgeInsets.all(8.0),
      flex: 1,
      child: SizedBox(
        width: 300.0,
        height: 200.0,
        child: box,
      ),
    );
    return column;
  }
}
