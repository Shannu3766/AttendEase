import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:attendease/firebase_options.dart';
import 'package:attendease/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterChat',
      home: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const WaitingScreen();
            // }
            if (snapshot.hasData) {
              user = FirebaseAuth.instance.currentUser!;
              // print(user);
              // return const DaySelectorWithSubjects();
            }
            // if (user != null && user!.photoURL == null) {
            //   return const User_Registration();
            // }
            // if (snapshot.hasData && user!.photoURL != null) {
            //   return const HomeScreen();
            // }
            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
