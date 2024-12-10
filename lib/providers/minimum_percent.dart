import 'package:flutter/foundation.dart';

class PercentProvider with ChangeNotifier {
  int _percent = 0; // Private field to store the percentage

  // Getter for percent
  int get percent => _percent;

  // Setter for percent
  set percent(int newPercent) {
    if (newPercent != _percent) {
      _percent = newPercent;
      notifyListeners(); // Notify listeners when the value changes
    }
  }
}
