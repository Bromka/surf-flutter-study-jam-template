import 'package:flutter/material.dart';

import 'package:surf_practice_chat_flutter/data/chat/models/message.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    this.chatElementData,
  }) : super(key: key);

  final ChatMessageDto? chatElementData;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.amber[600],
      child: Center(child: Text(chatElementData.toString())),
    );
  }
}
