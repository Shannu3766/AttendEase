import 'package:attendease/Classes/class_subject.dart';
import 'package:attendease/widgets/styledelevatedbutton.dart';
import 'package:attendease/widgets/widget_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  _AddSubjectScreenState createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  List<Subject> subjects = [];
  final user = FirebaseAuth.instance.currentUser;
  String subjectCode = "";
  String subjectTitle = "";
  bool isloading = false;
  late String Semster_num;
  @override
  void initState() {
    Semster_num = user!.displayName ?? '';
    fetchSubjects();
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  Future<void> fetchSubjects() async {
    try {
      setState(() {
        isloading = !isloading;
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
    } catch (error) {}
    setState(() {
      isloading = !isloading;
    });
  }

  void initalizeattendence() {
    for (int i = 0; i < subjects.length; i++) {
      FirebaseFirestore.instance
          .collection(user!.uid)
          .doc("Semester")
          .collection(Semster_num)
          .doc("Subjects")
          .collection(subjects[i].subname)
          .doc("Attendence")
          .set({
        'total': 0,
        'attended': 0,
      });
    }
  }

  void saveSubjects() async {
    try {
      // Prepare the data to save
      List<Map<String, String>> subjectsData = subjects.map((subject) {
        return {
          'subname': subject.subname,
          'subcode': subject.subcode,
        };
      }).toList();

      // Reference to the Firestore document
      final docRef = FirebaseFirestore.instance
          .collection(user!.uid)
          .doc("Semester")
          .collection(Semster_num)
          .doc("Subjects");

      // Overwrite the document with the new data (delete old and write new)
      await docRef.set({'subjects': subjectsData});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Subjects updated successfully!")),
      );
      Future.delayed(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).clearSnackBars();
      });

      // Fetch updated data from Firestore
      await fetchSubjects();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update subjects: $error")),
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      subjects.add(Subject(subname: subjectTitle, subcode: subjectCode));
    });

    _formKey.currentState!.reset();
    Navigator.pop(context); // Close the bottom sheet after submission
  }

  void showAddSubjectScreen() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            top: MediaQuery.of(context).size.height * 0.05,
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Adjust padding for the keyboard
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Subject Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a subject";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      subjectTitle = value!;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Subject Code",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a subject code";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      subjectCode = value!;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        iconColor: Colors.white,
                      ),
                      onPressed: _submit,
                      label: const Text(
                        "Add Subject",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(Icons.save),
                    ),
                  ),
                  SizedBox(height: 1000),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer_wid(),
      appBar: AppBar(
        title:
            Text("AttendEase", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isloading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: subjects.isEmpty
                        ? const Center(child: Text("No subjects added yet"))
                        : ListView.separated(
                            itemCount: subjects.length,
                            separatorBuilder: (context, index) =>
                                Divider(color: Colors.grey.shade300),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Card(
                                  elevation: 4,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(12.0),
                                    title: Text(
                                      subjects[index].subname,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      'Code: ${subjects[index].subcode}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          subjects.removeAt(index);
                                        });
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                    ),
                                    // leading:
                                  ),
                                ),
                              );
                            },
                          )

                    // : ListView.separated(
                    //     itemCount: subjects.length,
                    //     separatorBuilder: (context, index) =>
                    //         Divider(color: Colors.grey.shade300),
                    //     itemBuilder: (context, index) {
                    //       return Card(
                    //         elevation: 4,
                    //         margin: const EdgeInsets.symmetric(vertical: 8.0),
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(10)),
                    //         child: ListTile(
                    //           title: Text(subjects[index].subname),
                    //           subtitle:
                    //               Text('Code: ${subjects[index].subcode}'),
                    //           trailing: IconButton(
                    //             icon: const Icon(Icons.delete),
                    //             onPressed: () {
                    //               setState(() {
                    //                 subjects.removeAt(index);
                    //               });
                    //             },
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    ),
            !isloading
                ? Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Custom_ElevatedButtonicon(
                            function: showAddSubjectScreen,
                            icon: Icons.add,
                            text: "Add Sub",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Custom_ElevatedButtonicon(
                            function: saveSubjects,
                            icon: Icons.save,
                            text: "Save",
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(""),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showAddSubjectScreen();
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.blue,
      // ),
    );
  }
}
