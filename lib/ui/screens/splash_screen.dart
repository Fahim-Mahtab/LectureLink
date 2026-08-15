import 'package:flutter/material.dart';
import 'package:lecture_link/data/services/auth_service.dart';
import 'package:lecture_link/ui/screens/home_screen.dart';
import '../widgets/get_started_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && AuthService.instance.currentUser != null) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 100, color: Colors.white),
            const Text(
              "Lecture Link",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Academic Management System",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 100),

            const GetStartedButton(),
          ],
        ),
      ),
    );
  }
}
