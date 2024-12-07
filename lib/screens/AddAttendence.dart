import 'package:attendease/Classes/attendece.dart';
import 'package:attendease/Classes/class_subject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import this for date formatting

class AddAttendence extends StatefulWidget {
  @override
  _AddAttendenceState createState() => _AddAttendenceState();
}

class _AddAttendenceState extends State<AddAttendence> {
  DateTime selectedDate = DateTime.now();
  List<List<Subject>> weekdata = [];
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
            attended: subject['attended'],
          );
        }).toList();
        isdaydataavaliable = true;
      });
    } else {
      if (index_day == -1) {
        setState(() {
          attendece = [];
        });
        return;
      }
      setState(() {
        attendece = weekdata[index_day]
            .map((day) {
              return Attendece(
                  subname: day.subname, subcode: day.subcode, attended: true);
            })
            .cast<Attendece>()
            .toList();
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

  void update_attendece() async {
    final day =
        "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
    try {
      List<Map<String, dynamic>> serializedAttendance =
          attendece.map((a) => a.toMap()).toList();
      await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc("Attendence")
          .collection("sem1")
          .doc(day)
          .set({"subjects": serializedAttendance});
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Uploaded Successfully"),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      // ScaffoldMessenger.of(context).clearSnackBars();
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Upload Failed")));
    }
  }

  @override
  void initState() {
    get_weekdata();
    update_index_day();
    get_day_data_firebase();
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
              const SizedBox(height: 16),
              Text(
                "Selected Date: $formattedDate",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              attendece.isNotEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: attendece.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(attendece[index].subname),
                              subtitle: Text(attendece[index].subcode),
                              trailing: Checkbox(
                                value: attendece[index].attended,
                                onChanged: (value) {
                                  setState(() {
                                    attendece[index].attended = value!;
                                  });
                                },
                              ),
                              leading: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      attendece.removeAt(index);
                                    });
                                  },
                                  icon: Icon(Icons.delete)),
                            ),
                          );
                        },
                      ))
                  : Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        const Text(
                          "It's a Holiday...",
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
              attendece.isNotEmpty
                  ? ElevatedButton.icon(
                      icon: Icon(Icons.upload, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        update_attendece();
                      },
                      label: Text(
                        "Update Attendece",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Text(""),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectDate();
        },
        child: Icon(Icons.calendar_month_rounded), // Add an icon or text
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
