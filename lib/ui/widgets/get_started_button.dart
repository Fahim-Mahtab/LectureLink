import 'package:flutter/material.dart';
import 'package:lecture_link/data/services/auth_service.dart';
import 'package:lecture_link/ui/screens/main_screen.dart';
import 'package:lecture_link/ui/screens/sign_in_screen.dart';

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(40.0),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Material(
        color:Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(40.0),
          onTap: () {
            final nextRoute = AuthService.instance.currentUser != null
                ? MainScreen.routeName
                : SignInScreen.routeName;
            Navigator.pushReplacementNamed(
              context,
              nextRoute,
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 14.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.0),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 18.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
