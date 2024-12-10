import 'package:attendease/Classes/class_subject.dart';
import 'package:attendease/widgets/styledelevatedbutton.dart';
import 'package:attendease/widgets/widget_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTimetableScreen extends StatefulWidget {
  @override
  _AddTimetableScreenState createState() => _AddTimetableScreenState();
}

class _AddTimetableScreenState extends State<AddTimetableScreen> {
  final user = FirebaseAuth.instance.currentUser;
  List<String> Days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  List<Subject> subjects = [];
  List<List<Subject>> weekData = [[], [], [], [], [], []];
  bool isloading = false;
  var _selectedIndex = 0;
  late String Semster_num;
  Future<void> fetchSubjects() async {
    try {
      setState(() {
        isloading = true;
      });
      final docRef = FirebaseFirestore.instance
          .collection(user!.uid)
          .doc("Semester")
          .collection(Semster_num)
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
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch subjects: $error")),
      );
    }
    setState(() {
      isloading = false;
    });
  }

  void add_subject_to_day() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      weekData[_selectedIndex].add(subjects[index]);
                    });
                  },
                  child: ListTile(
                    title: Text(subjects[index].subname),
                    subtitle: Text(subjects[index].subcode),
                  ),
                );
              });
        });
  }

  Future<void> uploadTimetable() async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection(user!.uid)
          .doc("Semester")
          .collection(Semster_num)
          .doc("Timetable");

      List<Map<String, dynamic>> timetableData = weekData.map((day) {
        return {
          'subjects': day.map((subject) {
            return {
              'subname': subject.subname,
              'subcode': subject.subcode,
            };
          }).toList(),
        };
      }).toList();

      await docRef.set({'weekData': timetableData});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Timetable uploaded successfully")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload timetable: $error")),
      );
    }
  }

  Future<void> fetchWeekData() async {
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
      } else {
        setState(() {
          weekData = [[], [], [], [], [], []];
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch week data: $error")),
      );
    }
  }

  @override
  void initState() {
    Semster_num = user!.displayName ?? '';
    fetchSubjects();
    fetchWeekData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Subject> day_time = weekData[_selectedIndex];
    return MaterialApp(
      home: Scaffold(
        drawer: const drawer_wid(),
        appBar: AppBar(
          title: const Text("Attendease"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: _selectedIndex == -1
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05),
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: Days.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex =
                                        index; // Update the selected index
                                  });
                                },
                                child: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width * 0.05,
                                  backgroundColor: _selectedIndex == index
                                      ? Colors.blue // Highlighted color
                                      : Colors.grey[300], // Default color
                                  child: Text(
                                    Days[index][0],
                                    style: TextStyle(
                                      color: _selectedIndex == index
                                          ? Colors
                                              .white // Text color when selected
                                          : Colors.black, // Default text color
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: const Divider(
                          thickness: 2,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: day_time.isEmpty
                              ? Text("No data")
                              : ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      Divider(color: Colors.grey.shade300),
                                  itemCount: day_time.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Card(
                                        elevation: 4,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(12.0),
                                          title: Text(
                                            day_time[index].subname,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          subtitle: Text(
                                            day_time[index].subcode,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                weekData[_selectedIndex]
                                                    .removeAt(index);
                                                day_time =
                                                    weekData[_selectedIndex];
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
                                )),
                      // const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Custom_ElevatedButtonicon(
                                function: add_subject_to_day,
                                icon: Icons.add,
                                text: "Add Sub",
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Custom_ElevatedButtonicon(
                                function: uploadTimetable,
                                icon: Icons.save,
                                text: "Save",
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
