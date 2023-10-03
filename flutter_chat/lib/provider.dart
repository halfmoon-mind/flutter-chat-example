import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat/const/setting.dart';
import 'package:flutter_chat/model/room.dart';
import 'package:http/http.dart' as http;

class GlobalProvider extends ChangeNotifier {
  String _nickname = '';
  List<Room> roomList = [];

  /// 방 목록을 가져옵니다.
  void setRevoke() {
    http.get(Uri.parse('${ENV.API_URL}/rooms')).then((response) {
      if (response.statusCode == 200) {
        final result = json.decode(response.body)['rooms'] as List<dynamic>;

        roomList = result.map((room) => Room.fromJson(room)).toList();
        notifyListeners();
      }
    });
  }

  /// 닉네임을 설정합니다.
  void setNickname(String nickname) {
    _nickname = nickname;
    notifyListeners();
  }

  String get nickname => _nickname;
}
