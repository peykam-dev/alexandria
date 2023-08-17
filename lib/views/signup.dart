import 'package:alexandria/constants.dart';
import 'package:alexandria/helper/spref.dart';
import 'package:alexandria/service/auth.dart';
import 'package:alexandria/service/database.dart';
import 'package:alexandria/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'chat_room_screen.dart';

class SignUp extends StatefulWidget {
  final Function? toggle;
  const SignUp(this.toggle, {super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController tecName = TextEditingController();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPass = TextEditingController();

  signMeUp() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(tecEmail.text, tecPass.text)
          .then((val) {
        Map<String, String> userInfoMap = {
          "name": tecName.text,
          "email": tecEmail.text
        };
        SprefHelper.saveUsernameSpref(tecName.text);
        SprefHelper.saveUserEmailSpref(tecEmail.text);
        databaseMethods.uploadUserInfo(userInfoMap);
        SprefHelper.saveUserLogIn(true);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ChatRoomScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, []),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
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
                                    return val!.isEmpty || val.length < 5
                                        ? 'Boş goýmak bolmaýar'
                                        : null;
                                  },
                                  hintText: 'Ulanyjy ady',
                                  tec: tecName,
                                  hide: false),
                              customLoginField(
                                  validator: (val) {
                                    return RegExp(
                                                r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")
                                            .hasMatch(val!)
                                        ? null
                                        : '';
                                  },
                                  hintText: 'Email adres',
                                  tec: tecEmail,
                                  hide: false),
                              customLoginField(
                                  validator: (val) {
                                    return val!.length > 6
                                        ? null
                                        : "6 dan kop yaz";
                                  },
                                  hintText: 'Açar söz',
                                  tec: tecPass,
                                  hide: true),
                            ],
                          )),
                      const SizedBox(height: 8),
                      customOvalButton(
                          onTap: () => signMeUp(),
                          context: context,
                          text: 'Agza bol',
                          color1: const Color(0xff007ef4),
                          color2: const Color(0xff2a75bc),
                          tColor: Colors.white),
                      const SizedBox(height: 8),
                      customOvalButton(
                        onTap: () {},
                        context: context,
                        text: 'Google bilen agza bol',
                        color1: Colors.white,
                        color2: Colors.white,
                        tColor: Colors.black,
                      ),
                      const SizedBox(height: kDefPad / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Hasabyňyz barmy? ',
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                          InkWell(
                            onTap: () => widget.toggle?.call(),
                            child: const Text(
                              'Içeri gir',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 17,
                                  color: Colors.white),
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
