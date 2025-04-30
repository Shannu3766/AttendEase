import 'package:attendease/providers/semster_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Nodaysubjects extends StatefulWidget {
  const Nodaysubjects({super.key});

  @override
  State<Nodaysubjects> createState() => _NodaysubjectsState();
}

class _NodaysubjectsState extends State<Nodaysubjects> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.beach_access, size: 100, color: Colors.blue),
        SizedBox(height: 40),
        Text(
          "No Classes Added",
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
      ],
    );
  }
}
