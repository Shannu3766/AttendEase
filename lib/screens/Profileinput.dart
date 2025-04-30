import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:attendease/screens/Add_subjects.dart';
import 'package:attendease/widgets/CustomInputTile.dart';
import 'package:attendease/widgets/custome_dropdown.dart';
import 'package:attendease/widgets/styledelevatedbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phone = '';
  String college = '';
  String reqAttendance = '';
  String semester = '';
  final user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  Future<void> _updateDetails() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    await FirebaseFirestore.instance.collection(user!.uid).doc('details').set({
      'name': name,
      'phone': phone,
      'college': college,
      'req_Attendance': reqAttendance,
      'semester': semester,
    });
    await user?.updateDisplayName(semester);
    setState(() => _isLoading = false);
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddSubjectScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue.shade300),
        title: const Text(
          'Attendease',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECEFF3),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(-6, -6),
                            blurRadius: 16,
                          ),
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(6, 6),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assests/images/appicon.png',
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomInputTile(
                    intialvalue: name,
                    isnum: false,
                    icon: Icons.person,
                    labelText: 'Name',
                    onChanged: (v) => name = v,
                    validator:
                        (v) => v!.isEmpty ? 'Name cannot be empty' : null,
                  ),
                  CustomInputTile(
                    intialvalue: college,
                    isnum: false,
                    icon: Icons.school,
                    labelText: 'College',
                    onChanged: (v) => college = v,
                    validator:
                        (v) => v!.isEmpty ? 'College cannot be empty' : null,
                  ),
                  CustomInputTile(
                    intialvalue: phone,
                    isnum: true,
                    icon: Icons.phone,
                    labelText: 'Phone Number',
                    onChanged: (v) => phone = v,
                    validator: (v) {
                      if (v == null || v.length != 10) return 'Enter 10 digits';
                      return null;
                    },
                  ),
                  CustomInputTile(
                    intialvalue: reqAttendance,
                    isnum: true,
                    icon: Icons.percent,
                    labelText: 'Required Attendance %',
                    onChanged: (v) => reqAttendance = v,
                    validator: (v) {
                      final n = int.tryParse(v!);
                      if (n == null || n < 0 || n > 100) return '0-100 only';
                      return null;
                    },
                  ),
                  CustomDropdown(
                    hintText: 'Semester',
                    icon: FontAwesomeIcons.bookAtlas,
                    labelText: 'Semester',
                    onChanged: (v) => semester = v!,
                    validator:
                        (v) =>
                            v == null || v.isEmpty ? 'Select semester' : null,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Expanded(
                  //   child: ElevatedButton.icon(
                  //     onPressed: () {
                  //       Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //           builder: (_) => const AddSubjectScreen(),
                  //         ),
                  //       );
                  //     },
                  //     icon: const Icon(Icons.add),
                  //     label: const Text('Add Subject'),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.blue,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       padding: const EdgeInsets.symmetric(vertical: 16),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _updateDetails,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Save Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
