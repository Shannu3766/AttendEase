import 'package:attendease/screens/Home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:attendease/firebase_options.dart';
import 'package:attendease/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

//
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
// Platform  Firebase App Id
// web       1:36391741820:web:1a908b9910a52a28aadcf9
// android   1:36391741820:android:d09b42597902a973aadcf9

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
              print(user);
              return const AddSubjectScreen();
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
