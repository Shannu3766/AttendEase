import 'package:flutter/foundation.dart';

class SemsterProvider with ChangeNotifier {
  String _semster = "";

  // Getter for name
  String get semster => _semster;

  // Setter for name
  set semster(String newsemster) {
    _semster = newsemster;
    notifyListeners();
  }
}
