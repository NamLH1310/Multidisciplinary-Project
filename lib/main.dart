import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => const HomeScreen(),
    });
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
