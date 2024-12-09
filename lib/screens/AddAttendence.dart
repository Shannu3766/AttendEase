import 'package:attendease/Classes/attendece.dart';
import 'package:attendease/Classes/class_subject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

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
  List<Subject> subjects = [];
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    fetchSubjects();
    initializeData();
    super.initState();
  }

  void initializeData() async {
    // Initialize week data and attendance for the current day
    await get_weekdata();
    update_index_day();
    await get_day_data_firebase();
  }

  Future<void> fetchSubjects() async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection(user!.uid)
          .doc("Semester")
          .collection("Sem1")
          .doc("Subjects");

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        List<dynamic> fetchedSubjects = docSnapshot.data()?['subjects'] ?? [];

        setState(() {
          subjects = fetchedSubjects.map((subject) {
            return Subject(
              subname: subject['subname'],
              subcode: subject['subcode'],
            );
          }).toList();
        });
      } else {
        setState(() {
          subjects = [];
        });
      }
    } catch (error) {}
  }

  void add_subject() {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) {
          return Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (cotext, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            attendece.add(Attendece(
                              subname: subjects[index].subname,
                              subcode: subjects[index].subcode,
                              attended: true,
                            ));
                            Navigator.pop(context);
                          });
                        },
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              subjects[index].subname,
                              style: const TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              'Code: ${subjects[index].subcode}',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        });
  }

  void update_index_day() {
    int day = selectedDate.weekday;
    setState(() {
      if (day >= 1 && day <= 5) {
        index_day = day - 1; // Weekdays: Monday = 1, Sunday = 7
      } else {
        index_day = -1; // Weekend
      }
    });
  }

  Future<void> get_weekdata() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc("Semester")
          .collection("Sem1")
          .doc("Timetable")
          .get();

      if (snapshot.exists) {
        List<dynamic> fetchedWeekData = snapshot.data()?["weekData"] ?? [];
        setState(() {
          weekdata = fetchedWeekData.map((day) {
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
        print("No timetable data found.");
      }
    } catch (e) {
      print("Error fetching week data: $e");
    }
  }

  Future<void> get_day_data_firebase() async {
    try {
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
        if (index_day == -1 || weekdata.isEmpty) {
          setState(() {
            attendece = [];
            isdaydataavaliable = false;
          });
        } else {
          setState(() {
            attendece = weekdata[index_day]
                .map((subject) => Attendece(
                      subname: subject.subname,
                      subcode: subject.subcode,
                      attended: true,
                    ))
                .toList();
            isdaydataavaliable = true;
          });
        }
      }
    } catch (e) {
      print("Error fetching day data: $e");
    }
  }

  Future<void> update_attendece() async {
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Attendance updated successfully!")),
      );
    } catch (e) {
      print("Error updating attendance: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update attendance.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Tracker'),
        actions: [
          CircleAvatar(
            child: IconButton(
                onPressed: () {
                  attendece.isNotEmpty ? update_attendece : null;
                },
                icon: const Icon(Icons.save)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const SizedBox(width: 16),
              Text(
                "Date: $formattedDate",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              attendece.isNotEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                        itemCount: attendece.length,
                        itemBuilder: (context, index) {
                          return Card(
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
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text(
                        "It's a Holiday...",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.calendar_today, color: Colors.white),
            backgroundColor: Colors.green,
            label: 'Select Date',
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
                update_index_day();
                await get_day_data_firebase();
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.orange,
            label: 'Add Subject',
            onTap: () async {
              add_subject();
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.upload, color: Colors.white),
            backgroundColor: Colors.purple,
            label: 'Upload Attendance',
            onTap: () => update_attendece(),
          ),
        ],
      ),
    );
  }
}
