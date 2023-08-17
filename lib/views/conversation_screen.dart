import 'package:alexandria/constants.dart';
import 'package:alexandria/helper/userdata.dart';
import 'package:alexandria/service/database.dart';
import 'package:alexandria/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  const ConversationScreen({super.key, required this.chatRoomId});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController tecMessage = TextEditingController();
  Stream<QuerySnapshot>? chatMessagesStrm;
  final _controller = ScrollController();
  Widget chatMessagesList() {
    return StreamBuilder<QuerySnapshot>(
        stream: chatMessagesStrm,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            controller: _controller,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return MessageTile(
                  msg: data['message'],
                  isSendByMe: data['sendBy'] == UserData.myName);
            }).toList(),
          );
        });
  }

  sendMessage() async {
    if (tecMessage.text.isNotEmpty) {
      Map<String, dynamic> msgMap = {
        "message": tecMessage.text,
        "sendBy": UserData.myName,
        "time": DateTime.now().microsecondsSinceEpoch,
      };
      databaseMethods.addConvMessages(widget.chatRoomId, msgMap).then((val) {
        debugPrint(val.toString());
      });
    }
  }

  @override
  void initState() {
    chatMessagesStrm = databaseMethods.getConvMessages(widget.chatRoomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, []),
      body: Column(
        children: [
          Expanded(child: chatMessagesList()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: const Color(0x54ffffff),
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefPad, vertical: kDefPad / 2),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: tecMessage,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: 'Habar...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none),
                  )),
                  CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: IconButton(
                        onPressed: () {
                          sendMessage();
                          setState(() {
                            tecMessage.text = "";
                          });
                          if (_controller.hasClients) {
                            final position =
                                _controller.position.maxScrollExtent;
                            _controller.jumpTo(position);
                          }
                        },
                        icon: const Icon(Icons.send),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String msg;
  final bool isSendByMe;
  const MessageTile({super.key, required this.msg, required this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : kDefPad, right: isSendByMe ? kDefPad : 0),
      margin: const EdgeInsets.symmetric(vertical: kDefPad / 2),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefPad, vertical: kDefPad / 2),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [
                        const Color(0xff007ef4),
                        const Color(0xff2a75bc),
                      ]
                    : [
                        const Color(0x1affffff),
                        const Color(0x1affffff),
                      ]),
            borderRadius: isSendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(kDefPad),
                    topRight: Radius.circular(kDefPad),
                    bottomLeft: Radius.circular(kDefPad),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(kDefPad),
                    topRight: Radius.circular(kDefPad),
                    bottomRight: Radius.circular(kDefPad),
                  )),
        child: Text(
          msg,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
