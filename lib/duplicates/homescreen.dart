import 'package:attendease/Classes/class_subject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import this for date formatting

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  List<Subject> day_sub = [];
  List<Subject> selected_sub = [];
  var _selectedindex = -1;
  String day = '';
  bool _isloading = false;
  bool isday_data_avaliable = false;
  final user = FirebaseAuth.instance.currentUser;
  late String Semster_num;
  List<List<Subject>> weekData = [[], [], [], [], [], [], []];
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        day = _getDayOfWeek(selectedDate);
      });
    }
  }

  void fetchAttendanceForDay() async {
    try {
      setState(() {
        _isloading = true;
      });

      String dayId =
          "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
      final docRef = FirebaseFirestore.instance
          .collection(user!.uid)
          .doc("Attendance")
          .collection(Semster_num)
          .doc(dayId);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        Map<String, dynamic> attendanceData =
            Map<String, dynamic>.from(docSnapshot.data()!);

        setState(() {
          day_sub = weekData[_selectedindex].map((subject) {
            int count = attendanceData[subject.subcode] ?? 0;
            return Subject(
              subname: count > 0
                  ? "${subject.subname} (Count: $count)"
                  : subject.subname,
              subcode: subject.subcode,
            );
          }).toList();
          selected_sub = day_sub
              .where((subject) => attendanceData[subject.subcode] > 0)
              .toList();
        });
      } else {
        setState(() {
          day_sub = [];
          selected_sub = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No attendance data found for this day"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to fetch attendance: $error"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  Future<void> fetchWeekData() async {
    setState(() {
      _isloading = true;
    });
    try {
      final docRef = FirebaseFirestore.instance
          .collection(user!.uid)
          .doc("Semester")
          .collection(Semster_num)
          .doc("Timetable");

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        List<dynamic> fetchedWeekData = docSnapshot.data()?['weekData'] ?? [];

        setState(() {
          weekData = fetchedWeekData.map((day) {
            List<dynamic> subjectsList = day['subjects'] ?? [];
            return subjectsList.map((subject) {
              return Subject(
                subname: subject['subname'],
                subcode: subject['subcode'],
              );
            }).toList();
          }).toList();
        });
        _initializeSelectedSubjects();
      } else {
        setState(() {
          weekData = [[], [], [], [], [], [], []];
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch week data: $error")),
      );
    }
    setState(() {
      _isloading = false;
    });
  }

  void _initializeSelectedSubjects() {
    if (_selectedindex >= 0 && weekData[_selectedindex].isNotEmpty) {
      setState(() {
        selected_sub = List.from(weekData[_selectedindex]);
      });
    }
  }

  String _getDayOfWeek(DateTime date) {
    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    setState(() {
      _selectedindex = date.weekday - 1;
      _initializeSelectedSubjects(); // Update selected subjects for the current day
    });
    return days[date.weekday - 1];
  }

  void update_attendece() async {
    try {
      if (_selectedindex < 0 || selected_sub.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No subjects selected for attendance"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Formatting date for document ID
      String dayId =
          "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
      Map<String, dynamic> attendanceData = {};

      // Fetch existing attendance data from Firestore
      final docRef = FirebaseFirestore.instance
          .collection(user!.uid)
          .doc("Attendance")
          .collection(Semster_num)
          .doc(dayId);

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        attendanceData = Map<String, dynamic>.from(docSnapshot.data()!);
      }

      // Initialize all subjects for the selected day with default value 0 if not already present
      for (var sub in weekData[_selectedindex]) {
        attendanceData[sub.subcode] = attendanceData[sub.subcode] ?? 0;
      }

      // Increment attendance for selected subjects
      for (var sub in selected_sub) {
        if (attendanceData.containsKey(sub.subcode)) {
          attendanceData[sub.subcode] = (attendanceData[sub.subcode] ?? 0) + 1;
        }
      }

      // Update attendance in Firestore
      await docRef.set(attendanceData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Attendance successfully updated!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update attendance: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void initState() {
    day = _getDayOfWeek(DateTime.now());
    Semster_num = user!.displayName ?? '';
    fetchWeekData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: _isloading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    label: Text('$formattedDate'),
                    icon: Icon(Icons.calendar_month),
                    onPressed: () => _selectDate(context),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: weekData[_selectedindex].isNotEmpty
                        ? ListView.builder(
                            itemCount: weekData[_selectedindex].length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(
                                    weekData[_selectedindex][index].subname),
                                subtitle: Text(
                                    weekData[_selectedindex][index].subcode),
                                value: selected_sub
                                    .contains(weekData[_selectedindex][index]),
                                onChanged: (bool? isChecked) {
                                  setState(() {
                                    if (isChecked == true) {
                                      selected_sub
                                          .add(weekData[_selectedindex][index]);
                                    } else {
                                      selected_sub.remove(
                                          weekData[_selectedindex][index]);
                                    }
                                  });
                                },
                              );
                            },
                          )
                        : const Center(child: Text("It's a holiday")),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      update_attendece();
                    },
                    child: Text('Update Attendance'),
                  ),
                ],
              ),
      ),
    );
  }
}
