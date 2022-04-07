import 'package:flutter/material.dart';
import './graph_load.dart';

class LayOut extends StatefulWidget {
  const LayOut({Key? key, required this.nameType, required this.type})
      : super(key: key);
  final List<String> nameType;
  final List<String> type;

  @override
  State<LayOut> createState() => _LayOutState(nameType, type);
}

class _LayOutState extends State<LayOut> {
  final List<String> nameType;
  final List<String> type;
  _LayOutState(this.nameType, this.type);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            child: GraphDisplay(nameType: nameType[0], type: type[0]),
            height: size.height / 3,
            width: size.height / 3,
          ),
        ),
        Expanded(
          child: SizedBox(
            child: GraphDisplay(nameType: nameType[1], type: type[1]),
            height: size.height / 3,
            width: size.height / 3,
          ),
          //mainAxisAlignment: MainAxisAlignment.center,

          flex: 1,
        )
      ],
    );
  }
}

class ControlBoard extends StatefulWidget {
  const ControlBoard({Key? key}) : super(key: key);

  @override
  State<ControlBoard> createState() => _ControlBoardState();
}

class _ControlBoardState extends State<ControlBoard> {
  bool x = false;
  bool y = false;

  void sendDataX(bool y) => setState(() {
        x = !x;
      });
  void sendDataY(bool x) => setState(() {
        y = !y;
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Text("Current temp: "),
            Text("Current humid: "),
            Text("Current light: "),
            Text("current CO2: ")
          ],
        ),
        Row(
          children: [
            Switch(
              value: x,
              onChanged: sendDataX,
              activeColor: const Color.fromRGBO(200, 105, 40, 1),
              activeTrackColor: const Color.fromARGB(22, 0, 0, 1),
            ),
            Switch(
              value: y,
              onChanged: sendDataY,
              activeColor: const Color.fromRGBO(200, 105, 40, 1),
              activeTrackColor: const Color.fromARGB(22, 0, 0, 1),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}

class Name extends StatelessWidget {
  const Name({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text(title),
      )),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          LayOut(nameType: ["Celcious", "%"], type: ["Temp", "Humid"]),
          LayOut(nameType: ["Light", "%"], type: ["Lisght int", "Gas CO2"]),
          ControlBoard()
        ],
      )),
    ));
  }
}
