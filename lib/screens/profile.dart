import 'package:attendease/widgets/custome_dropdown.dart';
import 'package:attendease/widgets/widget_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var college = "";
  var name = "";
  var phone = "";
  var req_attendece = "";
  var semster = "";
  var email = "";
  final user = FirebaseAuth.instance.currentUser!;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void get_details() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(user.uid)
        .doc("details")
        .get();
    setState(() {
      name = snapshot['name'];
      email = user.email!;
      phone = snapshot['phone'];
      req_attendece = snapshot['req_Attendece'];
      college = snapshot['college'];
      semster = snapshot['semster'];
    });
  }

  @override
  void initState() {
    get_details();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer_wid(),
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Picture with Border
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 5.0,
                  ),
                ),
                child: const CircleAvatar(
                  // foregroundImage: NetworkImage(imageurl),
                  backgroundImage: const NetworkImage(
                      'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                  backgroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Details Section
              Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(email),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Phone'),
                        subtitle: Text(phone),
                      ),
                      Divider(),
                      ListTile(
                        leading: const Icon(Icons.location_city),
                        title: const Text('College'),
                        subtitle: Text(college),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.school),
                        title: const Text('Semster'),
                        subtitle: Text(semster),
                      ),
                    ],
                  ),
                ),
              ),
              // Logout Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    // Redirect to login screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    // primarycol: Colors.red, // Red color for logout
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Form(
                        key: formKey,
                        child: CustomDropdown(
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
                              return "Semester cannot be empty";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                          onPressed: () async {
                            var isvalid = formKey.currentState!.validate();
                            if (!isvalid) {
                              return;
                            }
                            Navigator.of(context).pop();
                            await user.updateDisplayName(semster);
                            await FirebaseFirestore.instance
                                .collection(user.uid)
                                .doc("details")
                                .update({'semster': semster});
                          },
                          label: Text("Update Semster")),
                    ],
                  ),
                );
              });
        },
        child: const Column(
          children: [
            const SizedBox(
              height: 4,
            ),
            Icon(Icons.edit),
            const Text("Update ")
          ],
        ),
      ),
    );
  }
}
