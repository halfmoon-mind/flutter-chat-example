import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat/room_list_screen.dart';
import 'package:http/http.dart' as http;

class GlobalProvider extends ChangeNotifier {
  List<Room> roomList = [];

  void setRevoke() {
    http.get(Uri.parse('http://localhost:3000/rooms')).then((response) {
      if (response.statusCode == 200) {
        final result = json.decode(response.body)['rooms'] as List<dynamic>;

        roomList = result.map((room) => Room.fromJson(room)).toList();
        notifyListeners();
      }
    });
    print("rovoked");
  }
}
