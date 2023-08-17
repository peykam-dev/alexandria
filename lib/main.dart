import 'package:alexandria/firebase_options.dart';
import 'package:alexandria/helper/authenticate.dart';
import 'package:alexandria/helper/spref.dart';
import 'package:alexandria/views/chat_room_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await SprefHelper.getUserLogIn().then((value) {
      debugPrint("This is $value");
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alexandria',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff1f1f1f),
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn ? const ChatRoomScreen() : const Authenticate(),
      // home: userIsLoggedIn
      //     ? userIsLoggedIn
      //         ? const ChatRoomScreen()
      //         : const Authenticate()
      //     : const IamBlank(),
    );
  }
}

class IamBlank extends StatelessWidget {
  const IamBlank({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
