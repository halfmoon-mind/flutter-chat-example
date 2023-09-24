import 'package:flutter/material.dart';
import 'package:flutter_chat/chat_screen.dart';
import 'package:flutter_chat/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Room {
  String roomCode;
  int memberCount;

  Room({required this.roomCode, required this.memberCount});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomCode: json['roomCode'],
      memberCount: json['memberCount'],
    );
  }

  Map<String, dynamic> toJson() => {
        'roomCode': roomCode,
        'memberCount': memberCount,
      };
}

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<GlobalProvider>(context, listen: false).setRevoke();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room List'),
        actions: [
          // make room
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result =
                  await http.post(Uri.parse('http://localhost:3000/room'));
              if (result.statusCode == 200) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(roomNumber: result.body),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: Provider.of<GlobalProvider>(context).roomList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                Provider.of<GlobalProvider>(context).roomList[index].roomCode),
            subtitle: Text(
                '${Provider.of<GlobalProvider>(context).roomList[index].memberCount} members'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                      roomNumber: Provider.of<GlobalProvider>(context)
                          .roomList[index]
                          .roomCode),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
