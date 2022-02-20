import 'package:flutter/material.dart';

import 'package:surf_practice_chat_flutter/data/chat/models/message.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    required this.chatElementData,
    this.userName,
  }) : super(key: key);

  bool isMyMessage() {
    if (this.userName == this.chatElementData.author) {
      return true;
    }
    return false;
  }

  final ChatMessageDto chatElementData;
  final String? userName;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Align(
      alignment: isMyMessage() ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: SizedBox(
              width: width * 0.7,
              height: height / 12,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF6f43bf),
                    child: Text(chatElementData.author.toString()[0]),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Text(chatElementData.author.toString()),
                      Text(chatElementData.message.toString())
                    ],
                  ))
                ],
              )

              // Text(chatElementData.message),
              ),
        ),
      ),
    );

    // Container(
    //   height: 50,
    //   color: Colors.amber[600],
    //   child: Center(child: Text(chatElementData.toString())),
    // );
  }
}
