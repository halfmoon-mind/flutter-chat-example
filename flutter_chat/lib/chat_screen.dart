import 'package:flutter/material.dart';
import 'package:flutter_chat/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  final String roomNumber;
  const ChatPage({required this.roomNumber, super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IO.Socket socket;
  late List<String> messages;
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    messages = [];
    textEditingController = TextEditingController();

    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      debugPrint('Connected');
      socket.emit('join_room', widget.roomNumber);
    });

    socket.on('receive_message', (jsonData) {
      print("Received message: $jsonData");
      setState(() {
        messages.add(jsonData);
      });
    });

    socket.on('set_username', (jsonData) {
      setState(() {
        messages.add(jsonData);
      });
    });

    socket.connect();
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      socket.emit('send_message', {
        'room': widget.roomNumber,
        'message': message,
      });
      textEditingController.clear();
    }
  }

  @override
  void dispose() {
    GlobalProvider().setRevoke();
    socket.emit('leave_room', widget.roomNumber);
    socket.disconnect();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socket.io Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration:
                        const InputDecoration(hintText: 'Enter message...'),
                    onSubmitted: (value) => _sendMessage(value),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(textEditingController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
