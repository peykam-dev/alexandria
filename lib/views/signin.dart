import 'package:alexandria/constants.dart';
import 'package:alexandria/helper/spref.dart';
import 'package:alexandria/service/auth.dart';
import 'package:alexandria/service/database.dart';
import 'package:alexandria/views/chat_room_screen.dart';
import 'package:alexandria/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function? toggle;
  const SignIn(this.toggle, {super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPass = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? snapUserInfo;
  signMeIn() {
    if (formKey.currentState!.validate()) {
      SprefHelper.saveUserEmailSpref(tecEmail.text);
      setState(() {
        isLoading = true;
      });
      databaseMethods.getUserByUserEmail(tecEmail.text).then((val) {
        snapUserInfo = val;
        SprefHelper.saveUsernameSpref(
            snapUserInfo!.docs[0].get("name").toString());
      });
      authMethods
          .signInWithEmailAndPass(tecEmail.text, tecPass.text)
          .then((value) {
        if (value != null) {
          SprefHelper.saveUserLogIn(true);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ChatRoomScreen()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, []),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: kDefPad),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        customLoginField(
                            validator: (val) {
                              return RegExp(
                                          r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")
                                      .hasMatch(val!)
                                  ? null
                                  : 'Email ýaz';
                            },
                            hintText: 'Email adres',
                            tec: tecEmail,
                            hide: false),
                        customLoginField(
                            validator: (val) {
                              return val!.length > 6 ? null : "6 dan köp ýaz";
                            },
                            hintText: 'Açar söz',
                            tec: tecPass,
                            hide: true),
                      ],
                    )),
                const SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefPad, vertical: kDefPad / 2),
                  child: const Text(
                    'Açar sözi unutdym?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                customOvalButton(
                    onTap: () => signMeIn(),
                    context: context,
                    text: 'Içeri gir',
                    color1: const Color(0xff007ef4),
                    color2: const Color(0xff2a75bc),
                    tColor: Colors.white),
                const SizedBox(height: 8),
                customOvalButton(
                  onTap: () {},
                  context: context,
                  text: 'Google bilen giriş',
                  color1: Colors.white,
                  color2: Colors.white,
                  tColor: Colors.black,
                ),
                const SizedBox(height: kDefPad / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hasabyňyz ýokmy? ',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    InkWell(
                      onTap: () => widget.toggle?.call(),
                      child: const Text(
                        'Agza boluň',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
