import 'package:attendease/screens/navigator.dart';
import 'package:attendease/widgets/CustomInputTile.dart';
import 'package:attendease/widgets/custome_dropdown.dart';
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
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return navigator();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomInputTile(
                      hintText: "Name",
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
                      hintText: "College",
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
                      hintText: "Phone Number",
                      icon: Icons.book,
                      labelText: "Phone Number",
                      onChanged: (value) {
                        setState(() {
                          phone = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone cannot be empty";
                        }
                        if (value.length != 10) {
                          return "Phone number should be of 10 digits";
                        }
                        return null;
                      },
                    ),
                    CustomInputTile(
                      hintText: "Req Attendece",
                      icon: Icons.person,
                      labelText: "Req Attendece",
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Attendence cannot be empty";
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
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                iconColor: Colors.white,
              ),
              icon: const Icon(Icons.upload),
              onPressed: () {
                update_details();
              },
              label: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            )
          ]),
        ),
      ),
    );
  }
}