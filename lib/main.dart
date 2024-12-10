import 'package:attendease/screens/AddAttendence.dart';
import 'package:attendease/screens/Profileinput.dart';
import 'package:attendease/screens/navigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:attendease/firebase_options.dart';
import 'package:attendease/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var user = FirebaseAuth.instance.currentUser;
  bool isnewuser = true;
  void get_details() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(user!.uid)
        .doc("details")
        .get();
    if (snapshot.exists) {
      setState(() {
        isnewuser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterChat',
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
              // return const navigator();
              return  AddAttendence();
            }
            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
