import 'package:alexandria/constants.dart';
import 'package:alexandria/helper/authenticate.dart';
import 'package:alexandria/helper/spref.dart';
import 'package:alexandria/helper/userdata.dart';
import 'package:alexandria/service/auth.dart';
import 'package:alexandria/service/database.dart';
import 'package:alexandria/views/conversation_screen.dart';
import 'package:alexandria/views/search.dart';
import 'package:alexandria/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream<QuerySnapshot>? chatRoomsStrm;
  Widget chatRoomList() {
    return StreamBuilder<QuerySnapshot>(
        stream: chatRoomsStrm,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.hasData
              ? ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return ChatRoomsTile(
                      userName: data['chatroomid']
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(UserData.myName, ""),
                      chatRoom: data['chatroomid'],
                    );
                  }).toList(),
                )
              : Container();
        });
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    UserData.myName = await SprefHelper.getUsernameSpref();
    setState(() {
      chatRoomsStrm = databaseMethods.getChatRooms(UserData.myName);
    });
    // databaseMethods.getChatRooms(UserData.myName).then((v) {
    //   setState(() {
    //     chatRoomsStrm = v;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(
        context,
        [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefPad),
            child: IconButton(
                onPressed: () {
                  authMethods.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Authenticate()));
                },
                icon: const Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      drawer: myDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SearchScreen())),
        child: const Icon(Icons.search),
      ),
      body: chatRoomList(),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoom;
  const ChatRoomsTile(
      {Key? key, required this.userName, required this.chatRoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId: chatRoom))),
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(
            horizontal: kDefPad, vertical: kDefPad / 2),
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Container(
              height: kDefPad * 2,
              width: kDefPad * 2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                userName.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: kDefPad / 2),
            Text(
              userName,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            )
          ],
        ),
      ),
    );
  }
}
