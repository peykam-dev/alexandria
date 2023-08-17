import 'package:alexandria/constants.dart';
import 'package:alexandria/views/drawer/about.dart';
import 'package:alexandria/views/drawer/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBar appBarMain(BuildContext context, List<Widget>? actions) {
  return AppBar(
    title: const Text('Alexandria'),
    actions: actions,
  );
}

TextFormField customLoginField({
  required String hintText,
  required TextEditingController tec,
  required bool hide,
  required String? Function(String?)? validator,
}) {
  return TextFormField(
    validator: validator,
    controller: tec,
    obscureText: hide,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white))),
  );
}

Widget customOvalButton(
    {required BuildContext context,
    required String text,
    required Color color1,
    required Color color2,
    required Color tColor,
    required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: kDefPad),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          // const Color(0xff007ef4),
          // const Color(0xff2a75bc),
          color1, color2
        ]),
        borderRadius: BorderRadius.circular(kDefPad + 10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: tColor,
          fontSize: 17,
        ),
      ),
    ),
  );
}

Drawer myDrawer(BuildContext context) {
  return Drawer(
    child: Container(
      decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //     begin: Alignment.bottomCenter,
          //     end: Alignment.topCenter,
          //     colors: [
          //       const Color.fromRGBO(0, 0, 100, 1),
          //       const Color.fromRGBO(100, 100, 100, 1),
          //     ])
          color: Color(0xff1f1f1f)),
      child: ListView(
        children: [
          const DrawerHeader(
              child: Column(
            children: [
              Text('Alexandria'),
              SizedBox(height: kDefPad / 2),
              Text(
                'v 1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )
            ],
          )),
          InkWell(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AboutScreen())),
            child: const ListTile(
              title: Text(
                'Programma barada',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsScreen())),
            child: const ListTile(
              title: Text(
                'Bildirişler',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          InkWell(
            onTap: () => SystemNavigator.pop(),
            child: const ListTile(
              title: Text(
                'Çykmak',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
