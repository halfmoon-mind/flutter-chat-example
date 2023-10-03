import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat/chat_screen.dart';
import 'package:flutter_chat/const/setting.dart';
import 'package:flutter_chat/model/room.dart';
import 'package:flutter_chat/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<GlobalProvider>(context, listen: false).setRevoke();
    Future.delayed(Duration.zero, () => setNickname());
  }

  void setNickname() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("닉네임을 설정하세요"),
        content: Material(
          child: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '닉네임',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Provider.of<GlobalProvider>(context, listen: false)
                  .setNickname(_textEditingController.text);
              _textEditingController.clear();
              GlobalProvider().setRevoke();
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  void _routeToChatPage(String roomCode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(roomCode: roomCode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Room List / ${Provider.of<GlobalProvider>(context).nickname}'),
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            Provider.of<GlobalProvider>(context, listen: false).setRevoke();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog.adaptive(
                  title: const Text("방 이름을 설정하세요"),
                  content: Material(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '방 이름',
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        final result =
                            await http.post(Uri.parse('${ENV.API_URL}/room'),
                                headers: {
                                  'Content-Type': 'application/json',
                                },
                                body: jsonEncode({
                                  'name': _textEditingController.text,
                                }));
                        final room = Room.fromJson(jsonDecode(result.body));

                        if (result.statusCode == 200) {
                          _routeToChatPage(room.id);
                        }
                      },
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: Provider.of<GlobalProvider>(context).roomList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title:
                Text(Provider.of<GlobalProvider>(context).roomList[index].name),
            subtitle: Text(
                '${Provider.of<GlobalProvider>(context).roomList[index].count} members'),
            trailing:
                Text(Provider.of<GlobalProvider>(context).roomList[index].id),
            onTap: () {
              _routeToChatPage(
                  Provider.of<GlobalProvider>(context, listen: false)
                      .roomList[index]
                      .id);
            },
          );
        },
      ),
    );
  }
}
