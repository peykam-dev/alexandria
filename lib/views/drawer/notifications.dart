import 'package:alexandria/constants.dart';
import 'package:alexandria/model/about.dart';
import 'package:alexandria/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String notifText = "";

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Future<NotifModel> fetchNotifText() async {
    await Future.delayed(const Duration(seconds: 5));
    final response = await http
        .get(Uri.http('allanazar.000webhostapp.com', 'alexandria.json'));
    List<dynamic> jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          if (jsonResponse.isNotEmpty) {
            for (int i = 0; i < jsonResponse.length; i++) {
              if (jsonResponse[i] != null) {
                Map<String, dynamic> map = jsonResponse[i];
                notifText = '${map['not']}';
              }
            }
          }
        });
      }
      return NotifModel.fromJson(jsonResponse[0]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    fetchNotifText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, []),
      body: Container(
        padding: const EdgeInsets.all(kDefPad),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              notifText == ""
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      notifText,
                      style: const TextStyle(color: Colors.white),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
