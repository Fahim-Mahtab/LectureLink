import 'package:flutter/material.dart';
import 'package:lecture_link/app/app_theme.dart';
import 'package:lecture_link/ui/screens/splash_screen.dart';
import 'package:lecture_link/ui/screens/sign_in_screen.dart';
import 'package:lecture_link/ui/screens/sign_up_screen.dart';
import 'package:lecture_link/ui/screens/home_screen.dart';

class LectureLink extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const LectureLink({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: SplashScreen.routeName,
      debugShowCheckedModeBanner: false,
      title: "Lecture Link",
      theme: AppTheme.lightTheme,
      routes: <String, WidgetBuilder>{
        SplashScreen.routeName: (_) => const SplashScreen(),
        SignInScreen.routeName: (_) => const SignInScreen(),
        SignUpScreen.routeName: (_) => const SignUpScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
      },
    );
  }
}
