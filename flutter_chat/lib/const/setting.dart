import 'package:flutter/foundation.dart';

class ENV {
  static const String API_URL =
      kReleaseMode ? 'http://api.lierchat.net' : 'http://localhost:3000';
}
