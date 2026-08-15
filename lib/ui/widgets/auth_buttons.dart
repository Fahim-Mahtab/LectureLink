import 'package:flutter/material.dart';
class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final String label;
  final IconData icon;
  final Color textColor;

  const AuthButton({
    required this.backgroundColor,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.textColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
