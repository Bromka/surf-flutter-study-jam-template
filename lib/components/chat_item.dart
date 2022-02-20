import 'package:flutter/material.dart';

import 'package:surf_practice_chat_flutter/data/chat/models/message.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    required this.chatElementData,
    this.isMy = false,
  }) : super(key: key);

  final ChatMessageDto chatElementData;
  final bool isMy;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          child: SizedBox(
            width: width / 0.6,
            height: height / 12,
            child: Text(chatElementData.message),
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
