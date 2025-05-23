import 'package:attendease/Classes/report_class.dart';
import 'package:attendease/providers/minimum_percent.dart';
import 'package:attendease/screens/AddAttendence.dart';
import 'package:attendease/screens/Add_subjects.dart';
import 'package:attendease/widgets/Nosubjects.dart';
import 'package:attendease/widgets/widget_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class generatereport extends StatefulWidget {
  const generatereport({super.key});

  @override
  State<generatereport> createState() => _generatereportState();
}

class _generatereportState extends State<generatereport> {
  final user = FirebaseAuth.instance.currentUser;
  var subjects = {};
  var subcodes = [];
  var no_attendance = false;
  String Semster_num = "";
  void getsubjects() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection(user!.uid)
            .doc("Semester")
            .collection(Semster_num)
            .doc("Subjects")
            .get();

    if (snapshot.exists && snapshot["subjects"].isNotEmpty) {
      for (var doc in snapshot["subjects"]) {
        subjects[doc['subcode']] = attendecereport(
          subname: doc['subname'],
          subcode: doc['subcode'],
          totalclasses: 0,
          attended: 0,
        );
        subcodes.add(doc['subcode']);
      }
    } else {
      print("No Subjects Found");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddSubjectScreen()),
      );
    }
  }

  void getreport() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection(user!.uid)
            .doc("Attendence")
            .collection("$Semster_num")
            .get();
    try {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          for (var doc in snapshot.docs) {
            final data = doc.data();
            for (var key in data["subjects"]) {
              subjects[key["subcode"]].totalclasses += 1;
              if (key["attended"] == true) {
                subjects[key["subcode"]].attended += 1;
              }
            }
          }
        });
      }
    } catch (e) {
      setState(() {
        no_attendance = true;
      });
    }
  }

  void print_data() {
    for (var key in subjects.keys) {
      //   // print((subjects[subcodes].attended) / (subjects[subcodes].totalclasses));
      print("Subject Name: ${subjects[key].subname}");
      print("Subject Code: ${subjects[key].subcode}");
      print("Total Classes: ${subjects[key].totalclasses}");
      print("Attended Classes: ${subjects[key].attended}");
      print(
        "Subject Name: ${((subjects[key].attended) / (subjects[key].totalclasses))}",
      );
    }
  }

  void initState() {
    Semster_num = user!.displayName ?? '';
    getsubjects();
    getreport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer_wid(),
      appBar: AppBar(title: const Text('Attendencee Report')),
      body:
          no_attendance
              ? Nosubjects(
                showAddSubjectScreen: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddAttendence()),
                  );
                },
                button_text: "Add your attendance",
                message: "No attendance data found",
              )
              : SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 1,
                        child: ListView.builder(
                          itemCount: subcodes.length,
                          itemBuilder: (context, index) {
                            final percent =
                                (subjects[subcodes[index]].attended) /
                                (subjects[subcodes[index]].totalclasses);
                            final percent_val = percent * 100;
                            return InkWell(
                              onTap: () {
                                // You can handle any tap actions here, if needed
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 12.0,
                                  ),
                                  leading: Text(
                                    subjects[subcodes[index]].totalclasses == 0
                                        ? "0.0 %"
                                        : "${percent_val.toStringAsFixed(1)} %",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  title: Text(
                                    subjects[subcodes[index]].subname,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "att/tot: ${subjects[subcodes[index]].attended}/${subjects[subcodes[index]].totalclasses}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  trailing: TweenAnimationBuilder(
                                    tween: Tween<double>(
                                      begin: 0.0, // Animation starts from 0
                                      end:
                                          (subjects[subcodes[index]]
                                                      .totalclasses ==
                                                  0)
                                              ? 0.0
                                              : (subjects[subcodes[index]]
                                                      .attended /
                                                  subjects[subcodes[index]]
                                                      .totalclasses),
                                    ),
                                    duration: const Duration(seconds: 1),
                                    builder: (context, double value, child) {
                                      return CircularProgressIndicator(
                                        value: value,
                                        color:
                                            percent_val <
                                                    context
                                                        .watch<
                                                          PercentProvider
                                                        >()
                                                        .percent
                                                ? Colors.red
                                                : Colors.green,
                                        strokeWidth:
                                            6, // You can adjust the thickness of the progress circle
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
