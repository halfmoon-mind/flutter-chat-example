import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat/const/setting.dart';
import 'package:flutter_chat/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String roomCode;
  const ChatPage({required this.roomCode, Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IO.Socket socket;
  late List<String> _messages;
  late TextEditingController _textEditingController;
  late String _nickname;

  @override
  void initState() {
    super.initState();
    _nickname = Provider.of<GlobalProvider>(context, listen: false).nickname;
    _messages = [];
    _textEditingController = TextEditingController();

    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io(ENV.API_URL, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      if (!mounted) return;
      debugPrint('Connected');
      socket.emit('join_room', {
        "room": widget.roomCode,
        "nickname": _nickname,
      });
    });

    _handleSocketEvents();
    socket.connect();
  }

  void _handleSocketEvents() {
    const eventNames = ['join_room', 'receive_message', 'set_username'];

    for (var eventName in eventNames) {
      if (eventName == 'join_room') continue;
      socket.on(eventName, _handleIncomingMessage);
    }
  }

  void _handleIncomingMessage(dynamic jsonData) {
    debugPrint(jsonData.toString());
    Map<String, dynamic> data;
    if (jsonData is Map) {
      data = jsonData as Map<String, dynamic>;
    } else {
      data = jsonDecode(jsonData.toString());
    }
    if (mounted) {
      setState(() {
        _messages.add('user: ${data['nickname']}, message: ${data['message']}');
      });
    }
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      socket.emit('send_message', {
        'room': widget.roomCode,
        'nickname': _nickname,
        'message': message,
      });
      _textEditingController.clear();
    }
  }

  void _leaveRoom() {
    socket.emit('leave_room', {'room': widget.roomCode});

    socket.on('left_room_confirm', (_) {
      socket.disconnect();
    });
  }

  @override
  void dispose() {
    _leaveRoom();
    super.dispose();
  }

  @override
  void deactivate() {
    Provider.of<GlobalProvider>(context, listen: false).setRevoke();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat / $_nickname'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(_messages[index]));
      },
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(hintText: 'Enter message...'),
              onSubmitted: (_) => _sendMessage(_textEditingController.text),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _sendMessage(_textEditingController.text),
          ),
        ],
      ),
    );
  }
}
