import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'room.freezed.dart';

@freezed
class Room with _$Room {
  const factory Room({
    required String roomCode,
    required int memberCount,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}
