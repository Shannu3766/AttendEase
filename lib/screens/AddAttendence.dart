import 'package:attendease/Classes/attendece.dart';
import 'package:attendease/Classes/class_subject.dart';
import 'package:attendease/providers/subjects_provider.dart';
import 'package:attendease/widgets/styledelevatedbutton.dart';
import 'package:attendease/widgets/widget_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_text/scrollable_text.dart';

class AddAttendence extends StatefulWidget {
  @override
  _AddAttendenceState createState() => _AddAttendenceState();
}

class _AddAttendenceState extends State<AddAttendence> {
  DateTime selectedDate = DateTime.now();
  List<List<Subject>> weekdata = [];
  List<Attendece> attendece = [];
  bool isdaydataavaliable = false;
  bool isloading = false;
  bool isonlinedata = false;
  int index_day = -1;
  List<Subject> subjects = [];
  late String Semster_num;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    Semster_num = user!.displayName ?? '';

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

  // void check_attendence() {
  // if (isdaydataavaliable) {
  //   showDialog(
  //     context: context,
  //     builder:
  //         (BuildContext context) => AlertDialog(
  //           title: Text("Attendance already exists"),
  //           content: Text("Do you want to update the attendance?"),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text("Ok"),
  //             ),
  //           ],
  //         ),
  //   );
  // }
  // }

  Future<void> fetchSubjects() async {
    setState(() {
      isloading = true;
    });
    try {
      final docRef = FirebaseFirestore.instance
          .collection(user!.uid)
          .doc("Semester")
          .collection(Semster_num)
          .doc("Subjects");

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        List<dynamic> fetchedSubjects = docSnapshot.data()?['subjects'] ?? [];

        setState(() {
          subjects =
              fetchedSubjects.map((subject) {
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
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Select a Subject',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child:
                    context.read<subjects_provider>().issubjectsfound
                        ? ListView.builder(
                          itemCount: subjects.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  attendece.add(
                                    Attendece(
                                      subname: subjects[index].subname,
                                      subcode: subjects[index].subcode,
                                      attended: true,
                                    ),
                                  );
                                  Navigator.pop(context);
                                });
                              },
                              child: Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 12.0,
                                  ),
                                  title: Text(
                                    subjects[index].subname,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Code: ${subjects[index].subcode}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                        : const Center(child: Text("No subjects found")),
              ),
            ],
          ),
        );
      },
    );
  }

  void update_index_day() {
    int day = selectedDate.weekday;
    if (mounted) {
      setState(() {
        if (day >= 1 && day <= 5) {
          index_day = day - 1; // Weekdays: Monday = 1, Sunday = 7
        } else {
          index_day = -1; // Weekend
        }
      });
    }
  }

  Future<void> get_weekdata() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection(user!.uid)
              .doc("Semester")
              .collection(Semster_num)
              .doc("Timetable")
              .get();

      if (snapshot.exists) {
        List<dynamic> fetchedWeekData = snapshot.data()?["weekData"] ?? [];
        setState(() {
          weekdata =
              fetchedWeekData.map((day) {
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
    setState(() {
      isloading = true;
    });
    try {
      final day =
          "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
      final snapshot =
          await FirebaseFirestore.instance
              .collection(user!.uid)
              .doc("Attendence")
              .collection(Semster_num)
              .doc(day)
              .get();
      print(snapshot.exists);
      print("---------------------------------------------------------");

      setState(() {
        isonlinedata = snapshot.exists;
      });

      if (snapshot.exists) {
        List<dynamic> fetchedSubjects = snapshot.data()?["subjects"] ?? [];
        setState(() {
          attendece =
              fetchedSubjects.map((subject) {
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
            attendece =
                weekdata[index_day]
                    .map(
                      (subject) => Attendece(
                        subname: subject.subname,
                        subcode: subject.subcode,
                        attended: true,
                      ),
                    )
                    .toList();
            isdaydataavaliable = true;
          });
        }
      }
    } catch (e) {
      print("Error fetching day data: $e");
    }
    setState(() {
      isloading = false;
    });
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
          .collection(Semster_num)
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

  void selectdate() async {
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
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    return Scaffold(
      drawer: drawer_wid(),
      appBar: AppBar(
        title: const Text(
          'Attendease',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (isonlinedata)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 8.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: ScrollableText(
                        'Attendance already exists.. Attendance already exists',
                        mode: ScrollableTextMode.endless,
                        velocity: const Velocity(
                          pixelsPerSecond: Offset(100, 0),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        selectable: true,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8.0,
                                offset: const Offset(0, 4), // Shadow position
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Selected Date:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ), // Spacing between container and button
                      CircleAvatar(
                        radius: 24.0,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          onPressed: () {
                            selectdate();
                          },
                          icon: const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child:
                        attendece.isNotEmpty
                            ? ListView.separated(
                              itemCount: attendece.length,
                              separatorBuilder:
                                  (context, index) =>
                                      Divider(color: Colors.grey.shade300),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      attendece[index].attended =
                                          !attendece[index].attended;
                                    });
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(
                                        12.0,
                                      ),
                                      title: Text(
                                        attendece[index].subname,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        attendece[index].subcode,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
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
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.library_books_outlined,
                                  size: 80,
                                  color: Colors.blue.shade300,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "It's a Holiday...",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ],
              ),
            ),
          ),
          if (isloading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: const LinearProgressIndicator(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          backgroundColor: Color(0xFFE3F2FD),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Fetching Subjects',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Custom_ElevatedButtonicon(
                function: add_subject,
                icon: Icons.add,
                text: "Add Sub",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Custom_ElevatedButtonicon(
                function: update_attendece,
                icon: Icons.save,
                text: "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
