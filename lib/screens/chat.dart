import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/components/chat_item.dart';

import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';

/// Chat screen templete. This is your starting point.
class ChatScreen extends StatefulWidget {
  final ChatRepository chatRepository;
  final String userName = 'DefaultName';
  final String? message = null;
  Future<List<dynamic>>? messages = null;
  bool _isSendButtonDisabled = true;

  ChatScreen({
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
    loadMessages();
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            onChanged: (val) => {validateButton()},
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
                loadMessages();
              },
            )
          ],
        ),
        body: FutureBuilder<List>(
            future: widget.messages,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    reverse: true,
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
                    onChanged: (val) => {validateButton()},
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
                onPressed: _messageController.text.length == 0
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

  sendMessage() async {
    final data = await widget.chatRepository
        .sendMessage(_userNameController.text, _messageController.text);
    print(data);
    // loadMessages();
  }

  loadMessages() async {
    setState(() {
      widget.messages = widget.chatRepository.messages;
    });
  }

  validateButton() {
    if (_messageController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty) {
      setState(() {
        widget._isSendButtonDisabled = false;
      });
    } else {
      setState(() {
        widget._isSendButtonDisabled = true;
      });
    }
  }
}
