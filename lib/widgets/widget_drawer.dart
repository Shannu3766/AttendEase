import 'package:attendease/providers/name_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:attendease/screens/AddAttendence.dart';
import 'package:attendease/screens/Add_subjects.dart';
import 'package:attendease/screens/Add_timtable_Screen.dart';
import 'package:attendease/screens/profile.dart';
import 'package:attendease/screens/report.dart';
import 'package:provider/provider.dart';

class drawer_wid extends StatefulWidget {
  const drawer_wid({super.key});

  @override
  State<drawer_wid> createState() => _drawer_widState();
}

class _drawer_widState extends State<drawer_wid> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            accountName: Text(
              "${context.watch<NameProvider>().name}" ?? "User Name",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              user?.email ?? "user@example.com",
              style: TextStyle(fontSize: 16),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : AssetImage('assets/images/default_avatar.png')
                      as ImageProvider,
              backgroundColor: Colors.white,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                buildDrawerItem(
                  context,
                  title: 'Attendance',
                  icon: Icons.assignment,
                  onTap: () => navigateTo(context, AddAttendence()),
                ),
                buildDrawerItem(
                  context,
                  title: 'Subjects',
                  icon: Icons.book,
                  onTap: () => navigateTo(context, AddSubjectScreen()),
                ),
                buildDrawerItem(
                  context,
                  title: 'Timetable',
                  icon: Icons.calendar_today,
                  onTap: () => navigateTo(context, AddTimetableScreen()),
                ),
                buildDrawerItem(
                  context,
                  title: 'Report',
                  icon: Icons.pie_chart,
                  onTap: () => navigateTo(context, generatereport()),
                ),
                buildDrawerItem(
                  context,
                  title: 'Profile',
                  icon: Icons.person,
                  onTap: () => navigateTo(context, ProfilePage()),
                ),
                buildDrawerItem(
                  context,
                  title: 'Logout',
                  icon: Icons.logout,
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                  textColor: Colors.red,
                  iconColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Function onTap,
    Color textColor = Colors.black,
    Color iconColor = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      onTap: () => onTap(),
      horizontalTitleGap: 8.0,
    );
  }

  void navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }
}
