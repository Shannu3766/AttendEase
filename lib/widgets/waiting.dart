import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return  Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(color: Colors.blue.shade50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.85,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade50,
                      blurRadius: 8.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Lottie.asset(
                        'assests/animation/loading.json',
                        width: screenWidth * 0.5,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Container(
                      width: screenWidth * 0.6,
                      child: const LinearProgressIndicator(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        backgroundColor: Color(0xFFE3F2FD),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please wait while we prepare your data',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}

void main() {
  runApp(const CircularProgress());
}
