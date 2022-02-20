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
      child: SizedBox(
          width: width * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: CircleAvatar(
                            backgroundColor: Color(0xFF6f43bf),
                            child: Text(
                              chatElementData.author.name.toString()[0],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                chatElementData.author.name.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                chatElementData.message.toString(),
                              )
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    chatElementData.createdDateTime.toLocal().toString(),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                )
              ],
            ),
          )

          // Text(chatElementData.message),
          ),
    );

    // Container(
    //   height: 50,
    //   color: Colors.amber[600],
    //   child: Center(child: Text(chatElementData.toString())),
    // );
  }
}
