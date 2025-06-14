import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attendease/Buttons/login_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _islogin = true;
  signinwithgoogle() async {
    GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? gauth = await googleuser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: gauth?.accessToken,
      idToken: gauth?.idToken,
    );
    UserCredential userCred =
        await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(169, 216, 243, 1),
          Color.fromARGB(255, 255, 255, 255)
        ], begin: Alignment.topRight, end: Alignment.bottomLeft),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Text(
                  "AttendEase",
                  style: GoogleFonts.pacifico(
                    fontSize: 48,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Image.asset(
                  'assests/images/appicon.png',
                  height: MediaQuery.of(context).size.height * 0.37,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 2.0,
                        endIndent: MediaQuery.of(context).size.width * 0.05,
                        indent: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                    Text(
                      _islogin ? "Login" : "Sign up",
                      style: GoogleFonts.inter(fontSize: 33.08),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 2.0,
                        endIndent: MediaQuery.of(context).size.width * 0.05,
                        indent: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              signinwithgoogle();
                              //   ScaffoldMessenger.of(context).clearSnackBars();
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(
                              //           content: Text('Authentication Success')));
                            },
                            child: const CustomButton())),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _islogin = !_islogin;
                    });
                  },
                  child: Text(
                    _islogin
                        ? "Create an Account?"
                        : "Already have an Account?",
                    style: const TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
