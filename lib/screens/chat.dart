import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/components/chat_item.dart';

import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';

/// Chat screen templete. This is your starting point.
class ChatScreen extends StatefulWidget {
  final ChatRepository chatRepository;
  final String userName = 'DefaultName';
  final String? message = null;
  final bool _isSendButtonDisabled = true;

  const ChatScreen({
    Key? key,
    required this.chatRepository,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _userNameController;
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.chatRepository.messages
    //     .then((messages) => messages.forEach((message) {
    //           print(message);
    //         }));
    // TODO(task): Use ChatRepository to implement the chat.
    print('hello world');

    final Future<List<dynamic>> messages = widget.chatRepository.messages;
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _userNameController,
            decoration: InputDecoration(
              hintText: 'Введите ник',
            ),
            maxLines: 1,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Обновить чат',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This is a snackbar')));
              },
            )
          ],
        ),
        body: FutureBuilder<List>(
            future: messages,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatItem(
                        chatElementData: snapshot.data?[index],
                      );
                    });
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(
                          value: null,
                          strokeWidth: 7.0,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25.0),
                      child: Center(
                        child: Text(
                          "loading.. wait...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Сообщение',
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              IconButton(
                disabledColor: Colors.grey,
                icon: const Icon(Icons.send),
                onPressed: widget._isSendButtonDisabled
                    ? null
                    : () {
                        sendMessage();
                      },
              ),
            ],
          ),
        ));
    throw UnimplementedError();
  }

  sendMessage() {
    print('something');

    print(_messageController.text);
    print(_userNameController.text);
  }
}
