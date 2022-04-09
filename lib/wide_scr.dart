import 'package:flutter/material.dart';
import 'graph_load.dart';


class layOut extends StatefulWidget {
  layOut({Key? key, required this.name_type, required this.type})
      : super(key: key);
  final List<String> name_type;
  final List<String> type;

  @override
  State<layOut> createState() => _layOutState(name_type, type);
}

class _layOutState extends State<layOut> {
  final List<String> name_type;
  final List<String> type;
  _layOutState(this.name_type, this.type);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          flex: 1,
          child:  SizedBox(child: GraphDisplay(nameType: name_type[0], type: type[0]),height:size.height/3,width: size.height/3,) ,
        ),
        Expanded(
          child: SizedBox(child: GraphDisplay(nameType: name_type[1], type: type[1]),height:size.height/3,width: size.height/3,) ,
            //mainAxisAlignment: MainAxisAlignment.center,
          
          flex: 1,
        )
      ],
    );
  }
}

class controlBoard extends StatefulWidget {
  controlBoard({Key? key}) : super(key: key);

  @override
  State<controlBoard> createState() => _controlBoardState();
}

class _controlBoardState extends State<controlBoard> {
  bool x = false;
  bool y = false;

  void sendData_x(bool y) => setState(() {
    x=!x;
  });
  void sendData_y(bool x) => setState(() {
        y = !y;
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Current temp: "),
            const Text("Current humid: "),
            const Text("Current light: "),
            const Text("current CO2: ")
          ],
        ),
        Row(
          children: [
            Switch(
              value: x,
              onChanged: sendData_x,
              activeColor: Color.fromRGBO(200, 105, 40, 1),
              activeTrackColor: Color.fromARGB(22, 0, 0, 1),
            ),
            Switch(
              value: y,
              onChanged: sendData_y,
              activeColor: Color.fromRGBO(200, 105, 40, 1),
              activeTrackColor: Color.fromARGB(22, 0, 0, 1),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}

class name extends StatelessWidget {
  const name({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
      appBar: AppBar(title: Center(child: Text(title),)),
      body: Center(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [layOut(name_type: ["Celcious","%"], type: ["Temp","Humid"]),
                layOut(name_type: ["Light","%"], type: ["Lisght int","Gas CO2"]),
                controlBoard()
              ]
          ,)
        ,)
      ),
    ));
  }
}
