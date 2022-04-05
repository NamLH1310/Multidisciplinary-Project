import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'graph_load.dart';
import 'package:http/http.dart' as http;
import 'wide_scr.dart';

void main() => runApp(name(title: "Plant"));
const String user_name = "";
const user_key = "";
const api =
    "https://io.adafruit.com/api/v2/BKHai/feeds/bbc-temp"; //thay cho nay

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Plant Monitor Planing'),
      home: graphDisplay(name_type: "Celcious ", type: "Temperature covering"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Album> futureAlbm;
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    futureAlbm = fetchAlbum();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
          child: FutureBuilder<Album>(
        future: futureAlbm,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.Name);
          } else {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Album {
  final String Name;
  final int value;
  final String time;
  const Album({required this.Name, required this.value, required this.time});
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        Name: json['name'], value: json['key'], time: (json['created_at']));
  }
}

Future<Album> fetchAlbum() async {
  final respone = await http.get(Uri.parse(api + "/data?limit=10"));
  if (respone.statusCode == 200) {
    print(respone.body);
    return Album.fromJson(jsonDecode(respone.body[0]));
  } else {
    print('failed');
    throw Exception(respone.statusCode);
  }
}
