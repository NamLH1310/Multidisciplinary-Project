import 'package:flutter/material.dart';
import '../screens/device_controller.dart';
import '../screens/home_screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: buildMenuItems(context),
      ),
    );
  }

  List<Widget> buildMenuItems(BuildContext context) {
    final List<String> menuTitles = [
      'Statistics',
      'Device controller',
    ];
    final List<Widget> menuItems = [];
    menuItems.add(const DrawerHeader(
      decoration: BoxDecoration(color: Colors.lightBlue),
      child: Text(
        "Smart Garden",
        style: TextStyle(
          fontSize: 28,
        ),
      ),
    ));

    for (var item in menuTitles) {
      Widget screen = Container();
      menuItems.add(ListTile(
        title: Text(
          item,
          style: const TextStyle(fontSize: 18),
        ),
        onTap: () {
          switch (item) {
            case 'Statistics':
              screen = const HomeScreen();
              break;
            case 'Device controller':
              screen = const DeviceController();
              break;
          }
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => screen,
          ));
        },
      ));
    }
    return menuItems;
  }
}
