import 'package:flutter/foundation.dart';
import 'package:attendease/Classes/class_subject.dart';

class subjects_provider with ChangeNotifier {
  bool _issubjectsfound = false;
  List<Subject> _subjects = [];

  // Getters
  bool get issubjectsfound => _issubjectsfound;
  List<Subject> get subjects => _subjects;

  void _updateState() {
    final newState = _subjects.isNotEmpty;
    print(
      "DEBUG: Current state - issubjectsfound: $_issubjectsfound, newState: $newState, subjects count: ${_subjects.length}",
    );
    _issubjectsfound = newState;
    notifyListeners();
    print("DEBUG: After notification - issubjectsfound: $_issubjectsfound");
  }

  // Function to update subjects list
  void updateSubjects(List<dynamic> fetchedSubjects) {
    print("DEBUG: Updating subjects with ${fetchedSubjects.length} items");
    _subjects =
        fetchedSubjects.map((subject) {
          return Subject(
            subname: subject['subname'],
            subcode: subject['subcode'],
          );
        }).toList();

    _updateState();
    print(
      "DEBUG: After update - subjects count: ${_subjects.length}, issubjectsfound: $_issubjectsfound",
    );
  }

  // Function to add a single subject
  void addSubject(Subject subject) {
    print("DEBUG: Adding subject ${subject.subname}");
    _subjects.add(subject);
    _updateState();
  }

  // Function to remove a subject
  void removeSubject(String subcode) {
    print("DEBUG: Removing subject with code $subcode");
    _subjects.removeWhere((subject) => subject.subcode == subcode);
    _updateState();
  }

  // Function to clear all subjects
  void clearSubjects() {
    print("DEBUG: Clearing all subjects");
    _subjects.clear();
    _updateState();
  }

  // Debug method to print current state
  void debugPrintState() {
    print("DEBUG: Current provider state:");
    print("issubjectsfound: $_issubjectsfound");
    print("subjects count: ${_subjects.length}");
    print("subjects: ${_subjects.map((s) => s.subname).toList()}");
  }
}
