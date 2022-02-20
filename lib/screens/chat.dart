import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_practice_chat_flutter/components/chat_item.dart';
import 'package:geolocator/geolocator.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';

/// Chat screen templete. This is your starting point.
class ChatScreen extends StatefulWidget {
  final ChatRepository chatRepository;
  String userName = 'DefaultName';
  final String message = '';
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
  late SharedPreferences username;

  void initial() async {
    username = await SharedPreferences.getInstance();
    setState(() {
      print(username.getString('username'));
      print('new name');
      if (username.getString('username').runtimeType == String) {
        widget.userName = 'some name';
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _userNameController = TextEditingController(text: widget.userName);
    _messageController = TextEditingController();
    initial();
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
            onChanged: (val) => {saveUserName(val)},
            controller: _userNameController,
            decoration: InputDecoration(
              hintText: 'Введите ник',
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
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
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List>(
                    future: widget.messages,
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            reverse: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ChatItem(
                                userName: _userNameController.text,
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
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 105, 124, 231),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintText: 'Сообщение',
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      IconButton(
                        disabledColor: Colors.grey,
                        icon: const Icon(Icons.location_pin),
                        onPressed: () {
                          sendGeo();
                        },
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
                ),
              ),
            ],
          ),
        ));

    throw UnimplementedError();
  }

  sendMessage() async {
    final data = await widget.chatRepository
        .sendMessage(_userNameController.text, _messageController.text);
    loadMessages();
    _messageController.clear();
  }

  loadMessages() async {
    setState(() {
      widget.messages = widget.chatRepository.messages;
    });
  }

  sendGeo() async {
    final pos = await _determinePosition;
    print(pos);
    final data = await widget.chatRepository
        .sendMessage(_userNameController.text, _messageController.text);
  }

  saveUserName(val) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('username', val);
    validateButton();
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
