import 'package:flutter/material.dart';
import '../responsive/home_screen_mobile.dart';
import '../responsive/home_screen_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: const HomeScreenMobile(),
      desktop: const HomeScreenWeb(),
    );
  }
}
