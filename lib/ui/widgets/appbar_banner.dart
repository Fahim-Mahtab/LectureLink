import 'package:flutter/material.dart';
import 'package:lecture_link/app/app_theme.dart';

class AppbarBanner extends StatefulWidget {
  const AppbarBanner({super.key});

  @override
  State<AppbarBanner> createState() => _AppbarBannerState();
}

class _AppbarBannerState extends State<AppbarBanner> {
  @override
  Widget build(BuildContext context) {
    return           Container(
      width: double.infinity,
      color: AppTheme.primaryBlue,
      padding: const EdgeInsets.only(
        top: 70.0,
        left: 24.0,
        right: 24.0,
        bottom: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "LectureLink",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            "Welcome back",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Sign in to your teacher account",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
