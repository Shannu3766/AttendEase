import 'package:attendease/screens/Add_subjects.dart';
import 'package:attendease/widgets/CustomInputTile.dart';
import 'package:attendease/widgets/custome_dropdown.dart';
import 'package:attendease/widgets/styledelevatedbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var name = "";
  var phone = "";
  var college = "";
  var req_Attendece = "";
  var semster = "";
  final user = FirebaseAuth.instance.currentUser;

  void update_details() async {
    var isvalid = formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    formKey.currentState!.save();
    await FirebaseFirestore.instance.collection(user!.uid).doc('details').set({
      'name': name,
      'phone': phone,
      'college': college,
      'req_Attendece': req_Attendece,
      'semster': semster,
    });
    await user?.updateDisplayName(semster);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const AddSubjectScreen();
    }));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendease'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Form(
                key: formKey,
                child: Column(
                  children: [
                    Image.asset(
                      "assests/images/appicon.png",
                      height: MediaQuery.of(context).size.height * 0.23,
                    ),
                    CustomInputTile(
                      intialvalue: name,
                      isnum: false,
                      icon: Icons.person,
                      labelText: "Name",
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name cannot be empty";
                        }
                        return null;
                      },
                    ),
                    CustomInputTile(
                      intialvalue: college,
                      isnum: false,
                      // hintText: "College",
                      icon: Icons.school,
                      labelText: "College",
                      onChanged: (value) {
                        setState(() {
                          college = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "College cannot be empty";
                        }
                        return null;
                      },
                    ),
                    CustomInputTile(
                      intialvalue: phone,
                      // hintText: "Phone Number",
                      icon: Icons.book,
                      labelText: "Phone Number",
                      isnum: true,
                      onChanged: (value) {
                        setState(() {
                          phone = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone cannot be empty";
                        }
                        try {
                          var num = int.parse(value);
                        } catch (e) {
                          return "should be an integer";
                        }
                        if (value.length != 10) {
                          return "Phone number should be of 10 digits";
                        }

                        return null;
                      },
                    ),
                    CustomInputTile(
                      intialvalue: req_Attendece,
                      // hintText: "Req Attendece",
                      icon: Icons.person,
                      labelText: "Req Attendece",
                      isnum: true,
                      onChanged: (value) {
                        setState(() {
                          req_Attendece = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Attendence cannot be empty";
                        }
                        try {
                          var num = int.parse(value);
                        } catch (e) {
                          return "should be an integer";
                        }
                        return null;
                      },
                    ),
                    CustomDropdown(
                      hintText: "Semester",
                      icon: FontAwesomeIcons.bookAtlas,
                      labelText: "Semester",
                      onChanged: (value) {
                        setState(() {
                          semster = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Semster cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Custom_ElevatedButtonicon(
                function: update_details,
                icon: Icons.upload,
                text: "Submit",
              ),
            )
          ]),
        ),
      ),
    );
  }
}
