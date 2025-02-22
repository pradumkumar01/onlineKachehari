import 'package:flutter/material.dart';

class ChatHistoryWakeel extends StatefulWidget {
  const ChatHistoryWakeel({super.key});

  @override
  State<ChatHistoryWakeel> createState() => _ChatHistoryWakeelState();
}

class _ChatHistoryWakeelState extends State<ChatHistoryWakeel> {
  var titles = [
    'Wakeel one ',
    'Wakeel two ',
    'Wakeel three ',
    'Wakeel four',
    'Wakeel five',
    'Wakeel six ',
    'Wakeel seven ',
    'Wakeel eight ',
    'Wakeel nine',
    'Wakeel ten',
    'Wakeel eleven ',
    'Wakeel teelve ',
    'Wakeel thirteen ',
    'Wakeel fourteen',
    'Wakeel fifteen'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Chat history",
            style: TextStyle(
                fontFamily: "serif", fontSize: 21, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.blue.withOpacity(0.9),
              Colors.lightBlue.withOpacity(0.3),
            ])),
          ),
        ),
        body: ListView.separated(
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Card(
                      elevation: 5,
                      shape: const CircleBorder(
                          side: BorderSide(color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 55,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        titles[index],
                        style: const TextStyle(
                            fontFamily: "serif",
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(11.0),
                  child: Text(
                    "Chat again",
                    style: TextStyle(fontFamily: "serif", fontSize: 16),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: titles.length,
        ));
  }
}
