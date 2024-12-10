import 'package:attendease/Classes/report_class.dart';
import 'package:attendease/widgets/widget_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class generatereport extends StatefulWidget {
  const generatereport({super.key});

  @override
  State<generatereport> createState() => _generatereportState();
}

class _generatereportState extends State<generatereport> {
  final user = FirebaseAuth.instance.currentUser;
  var subjects = {};
  var subcodes = [];
  String Semster_num = "";
  void getsubjects() async {
    final snapshot = await FirebaseFirestore.instance
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
    }
  }

  void getreport() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(user!.uid)
        .doc("Attendence")
        .collection("$Semster_num")
        .get();
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
  }

  void print_data() {
    for (var key in subjects.keys) {
      //   // print((subjects[subcodes].attended) / (subjects[subcodes].totalclasses));
      print("Subject Name: ${subjects[key].subname}");
      print("Subject Code: ${subjects[key].subcode}");
      print("Total Classes: ${subjects[key].totalclasses}");
      print("Attended Classes: ${subjects[key].attended}");
      print(
          "Subject Name: ${((subjects[key].attended) / (subjects[key].totalclasses))}");
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
      appBar: AppBar(
        title: const Text('Attendencee Report'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: subjects.isEmpty
              ? Text("No subjects added")
              : Column(
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
                            return Card(
                                elevation: 4,
                                child: ListTile(
                                  leading: Text(
                                    subjects[subcodes[index]].totalclasses == 0
                                        ? "0.0 %"
                                        : "${percent_val.toStringAsFixed(1)} %",
                                  ),
                                  title:
                                      Text(subjects[subcodes[index]].subname),
                                  subtitle: Text(
                                      "att/tot: ${subjects[subcodes[index]].attended}/${subjects[subcodes[index]].totalclasses}"),
                                  trailing: TweenAnimationBuilder(
                                    tween: Tween<double>(
                                      begin: 0.0, // Animation starts from 0
                                      end: ((subjects[subcodes[index]]
                                                  .totalclasses) ==
                                              0)
                                          ? 0.5
                                          : (subjects[subcodes[index]]
                                                  .attended /
                                              subjects[subcodes[index]]
                                                  .totalclasses),
                                    ),
                                    duration: const Duration(seconds: 1),
                                    builder: (context, double value, child) {
                                      return CircularProgressIndicator(
                                        value: value,
                                        color: value < 0.75
                                            ? Colors.red
                                            : Colors.green,
                                      );
                                    },
                                  ),
                                ));
                          }),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
