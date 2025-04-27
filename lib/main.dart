import 'package:attendease/Classes/firebase_notification.dart';
import 'package:attendease/providers/minimum_percent.dart';
import 'package:attendease/providers/name_provider.dart';
import 'package:attendease/screens/AddAttendence.dart';
import 'package:attendease/screens/Add_subjects.dart';
import 'package:attendease/screens/Add_timtable_Screen.dart';
import 'package:attendease/screens/Profileinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:attendease/firebase_options.dart';
import 'package:attendease/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow;
    }
    // else, ignore the duplicate app error
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NameProvider()),
        ChangeNotifierProvider(create: (context) => PercentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var user = FirebaseAuth.instance.currentUser;
  bool isnewuser = true;
  var name = "";
  void get_details() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection(user!.uid)
            .doc("details")
            .get();
    if (snapshot.exists) {
      setState(() {
        isnewuser = false;
        context.read<NameProvider>().name = snapshot['name'];
        context.read<PercentProvider>().percent = int.parse(
          snapshot['req_Attendece'],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendease',
      home: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              user = FirebaseAuth.instance.currentUser;
              get_details();
              if (isnewuser) {
                return const ProfileScreen();
              }
              return AddTimetableScreen();
            }
            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
