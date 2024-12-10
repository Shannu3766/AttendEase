import 'package:flutter/foundation.dart';

class NameProvider with ChangeNotifier {
  String _name = "";

  // Getter for name
  String get name => _name;

  // Setter for name
  set name(String newName) {
    _name = newName;
    notifyListeners();
  }
}
