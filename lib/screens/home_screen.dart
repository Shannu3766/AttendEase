import 'package:attendease/Classes/attendece.dart';
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
  List<List<Subject>> weekdata = [];
  List<Subject> subject_of_the_day = [];
  List<Attendece> attendece = [];
  bool isdaydataavaliable = false;
  int index_day = -1;
  List<Subject> today_attendece = [];
  final user = FirebaseAuth.instance.currentUser;
  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        isdaydataavaliable = false;
      });
    }
    update_index_day();
    get_day_data_firebase();
  }

  void get_day_data_firebase() async {
    final day =
        "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
    final snapshot = await FirebaseFirestore.instance
        .collection(user!.uid)
        .doc("Attendence")
        .collection("sem1")
        .doc(day)
        .get();
    if (snapshot.exists) {
      List<dynamic> fetchedSubjects = snapshot.data()?["subjects"] ?? [];
      setState(() {
        attendece = fetchedSubjects.map((subject) {
          return Attendece(
            subname: subject['subname'],
            subcode: subject['subcode'],
            total: subject['totalClasses'],
            attended: subject['attendedClasses'],
          );
        }).toList();
        isdaydataavaliable = true;
      });
    } else {
      if (index_day == -1) {
        setState(() {
          subject_of_the_day = [];
        });
        return;
      }
      setState(() {
        subject_of_the_day = weekdata[index_day].map((day) {
          return Subject(
            subname: day.subname,
            subcode: day.subcode,
          );
        }).toList();
      });
    }
  }

  void get_weekdata() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(user!.uid)
        .doc("Semester")
        .collection("Sem1")
        .doc("Timetable")
        .get();
    if (snapshot.exists) {
      List<dynamic> fetchedweekdata = snapshot.data()?["weekData"] ?? [];
      setState(() {
        weekdata = fetchedweekdata.map((day) {
          List<dynamic> subjectsList = day['subjects'] ?? [];
          return subjectsList.map((subject) {
            return Subject(
              subname: subject['subname'],
              subcode: subject['subcode'],
            );
          }).toList();
        }).toList();
      });
    } else {
      print("No data found");
    }
  }

  void update_index_day() {
    int day = selectedDate.weekday;
    setState(() {
      if (day >= 1 && day <= 5) {
        index_day = day - 1;
      } else {
        index_day = -1;
      }
    });
  }

  @override
  void initState() {
    get_weekdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: _selectDate,
                label: Text("Pick the date"),
                icon: Icon(Icons.calendar_month_outlined),
              ),
              const SizedBox(height: 40),
              isdaydataavaliable
                  ? Text("Data is available")
                  : subject_of_the_day.isNotEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: ListView.builder(
                              itemCount: subject_of_the_day.length,
                              itemBuilder: (context, index) {
                                return CheckboxListTile(
                                  value: today_attendece
                                      .contains(subject_of_the_day[index]),
                                  title:
                                      Text(subject_of_the_day[index].subname),
                                  subtitle:
                                      Text(subject_of_the_day[index].subcode),
                                  onChanged: (bool? isChecked) {
                                    setState(() {
                                      if (isChecked == true) {
                                        today_attendece
                                            .add(subject_of_the_day[index]);
                                      } else {
                                        today_attendece
                                            .remove(subject_of_the_day[index]);
                                      }
                                    });
                                  },
                                );
                              }),
                        )
                      : Text("Data is not available"),
              ElevatedButton(
                onPressed: () {
                  print(weekdata);
                  print(subject_of_the_day);
                },
                child: Text("Debug"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
