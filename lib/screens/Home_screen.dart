// // import 'package:attendease/widgets/add_sub.dart';
// // import 'package:attendease/widgets/subjects_list.dart';
// import 'package:attendease/Classes/class_subject.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:flutter/material.dart';

// class AddSubjectScreen extends StatefulWidget {
//   const AddSubjectScreen({super.key});
//   @override
//   _AddSubjectScreenState createState() => _AddSubjectScreenState();
// }

// class _AddSubjectScreenState extends State<AddSubjectScreen> {
//   final _formkey = GlobalKey<FormState>();
//   final FocusNode _focusNode = FocusNode();
//   List<Subject> subjects = [];
//   final user = FirebaseAuth.instance.currentUser;
//   // List<Subject> get subject =
//   var subject_code = "";
//   var subject_title = "";
//   @override
//   @override
//   void initState() {
//     fetchSubjects(); //
//     super.initState();
//     _focusNode.addListener(() {
//       setState(() {});
//     });
//   }

//   Future<void> fetchSubjects() async {
//     try {
//       // Reference to the document
//       final docRef = FirebaseFirestore.instance
//           .collection(user!.uid) // User-specific collection
//           .doc("Semester") // Top-level document
//           .collection("Sem1") // Sub-collection
//           .doc("Subjects"); // Specific document for subjects

//       // Fetch the document
//       final docSnapshot = await docRef.get();

//       if (docSnapshot.exists) {
//         // Extract subjects from Firestore
//         List<dynamic> fetchedSubjects = docSnapshot.data()?['subjects'] ?? [];

//         // Map the Firestore data to the local subjects list
//         setState(() {
//           subjects = fetchedSubjects.map((subject) {
//             return Subject(
//               subname: subject['subname'],
//               subcode: subject['subcode'],
//             );
//           }).toList();
//         });
//       } else {
//         setState(() {
//           subjects = []; // If no data, reset the list
//         });
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to fetch subjects: $error")),
//       );
//     }
//   }

//   void save_subjects() async {
//     try {
//       // Prepare the data to save
//       List<Map<String, String>> subjectsData = subjects.map((subject) {
//         return {
//           'subname': subject.subname,
//           'subcode': subject.subcode,
//         };
//       }).toList();

//       // Save the data to Firestore
//       await FirebaseFirestore.instance
//           .collection(user!.uid) // user!.uid is the user-specific collection
//           .doc("Semster")
//           .collection("Sem1")
//           .doc(user!.uid) // Document name
//           .set({'subjects': subjectsData}); // Store as a list of maps

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Subjects saved successfully!")),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to save subjects: $error")),
//       );
//     }
//   }

//   Future<void> _submit() async {
//     final isValid = _formkey.currentState!.validate();
//     if (!isValid) {
//       return;
//     }
//     setState(() {
//       subjects.add(Subject(subname: subject_title, subcode: subject_code));
//     });
//     _formkey.currentState!.save();
//     _formkey.currentState!.reset();
//   }

//   void showaddsubject_screen() {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return Padding(
//             padding: EdgeInsets.only(
//                 left: MediaQuery.of(context).size.width * 0.05,
//                 right: MediaQuery.of(context).size.width * 0.05,
//                 top: MediaQuery.of(context).size.height * 0.05),
//             child: Form(
//               key: _formkey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     textCapitalization: TextCapitalization.sentences,
//                     keyboardType: TextInputType.text,
//                     decoration: const InputDecoration(
//                       hintText: "Add Subject",
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter a subject";
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       subject_title = value!;
//                     },
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.05,
//                   ),
//                   TextFormField(
//                     textCapitalization: TextCapitalization.sentences,
//                     keyboardType: TextInputType.text,
//                     decoration: const InputDecoration(
//                       hintText: "Subject Code",
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter a subject code";
//                       }
//                       return null;
//                     },
//                     onSaved: (Value) {
//                       subject_code = Value!;
//                     },
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.05,
//                   ),
//                   Center(
//                     child: ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(),
//                         onPressed: () {
//                           _submit();
//                         },
//                         label: Text("Add Subject"),
//                         icon: Icon(Icons.add)),
//                   )
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Add Subject"),
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(
//               right: MediaQuery.of(context).size.width * 0.05,
//             ),
//             child: IconButton(
//               onPressed: () {
//                 save_subjects();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Subjects saved")));
//               },
//               icon: const Icon(Icons.save),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Top Half: Subject List
//           Expanded(
//               flex: 2,
//               child: subjects.isEmpty
//                   ? const Center(child: Text("No subjects added yet"))
//                   : ListView.builder(
//                       itemCount: subjects.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(subjects[index].subname),
//                           subtitle: Text('Code: ${subjects[index].subcode}'),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () {
//                               setState(() {
//                                 subjects.removeAt(index);
//                               });
//                             },
//                           ),
//                         );
//                       },
//                     )),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).size.height * 0.02),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       showaddsubject_screen();
//                     },
//                     child: const Text("Add Subject"),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       showaddsubject_screen();
//                     },
//                     child: const Text("Add Subject"),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:attendease/Classes/class_subject.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  void initState() {
    fetchSubjects();
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
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
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch subjects: $error")),
      );
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
          .collection("Sem1")
          .doc("Subjects");

      // Overwrite the document with the new data (delete old and write new)
      await docRef.set({'subjects': subjectsData});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Subjects updated successfully!")),
      );

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
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.05,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Add Subject",
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
                    onPressed: _submit,
                    label: const Text("Add Subject"),
                    icon: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Subject"),
        actions: [
          IconButton(
            onPressed: saveSubjects,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: subjects.isEmpty
                ? const Center(child: Text("No subjects added yet"))
                : ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(subjects[index].subname),
                        subtitle: Text('Code: ${subjects[index].subcode}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              subjects.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.02,
            ),
            child: ElevatedButton(
              onPressed: showAddSubjectScreen,
              child: const Text("Add Subject"),
            ),
          ),
        ],
      ),
    );
  }
}
