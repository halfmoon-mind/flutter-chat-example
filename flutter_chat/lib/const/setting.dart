import 'package:flutter/foundation.dart';

class ENV {
  static const String API_URL =
      kReleaseMode ? 'http://3.36.79.20:3000' : 'http://localhost:3000';
}
