import 'package:alexandria/constants.dart';
import 'package:alexandria/helper/userdata.dart';
import 'package:alexandria/service/database.dart';
import 'package:alexandria/views/conversation_screen.dart';
import 'package:alexandria/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController tecSearch = TextEditingController();
  QuerySnapshot? searchSnap;

  initiateSearch() {
    databaseMethods.getUserByUsername(tecSearch.text).then((val) {
      setState(() {
        searchSnap = val;
      });
    });
  }

  Widget searchList() {
    return searchSnap != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnap!.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnap!.docs[index].get("name").toString(),
                userEmail: searchSnap!.docs[index].get("email").toString(),
              );
            },
          )
        : Container();
  }

  createRoomAndStartConv({required String username}) {
    if (username != UserData.myName) {
      String chatRoomId = getChatRoomId(username, UserData.myName);
      List<String> users = [username, UserData.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId: chatRoomId,
                  )));
    } else {}
  }

  Widget searchTile({required String userName, required String userEmail}) {
    return Container(
      padding: const EdgeInsets.all(kDefPad),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
              Text(userEmail.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  )),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () => createRoomAndStartConv(username: userName),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefPad, vertical: kDefPad / 2),
              child: const Text('Habarlaş',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, []),
      body: Column(
        children: [
          Container(
            color: const Color(0x54ffffff),
            padding: const EdgeInsets.symmetric(
                horizontal: kDefPad, vertical: kDefPad / 2),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: tecSearch,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      hintText: 'Gözleg...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none),
                )),
                CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: IconButton(
                      onPressed: () => initiateSearch(),
                      icon: const Icon(Icons.search),
                    )),
              ],
            ),
          ),
          searchList(),
        ],
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "${b}_$a";
  } else {
    return "${a}_$b";
  }
}
