import 'package:flutter/material.dart';
import 'package:lecture_link/ui/screens/splash_screen.dart';
import 'package:lecture_link/ui/screens/sign_in_screen.dart';
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
      theme: ThemeData(useMaterial3: true),
      routes: <String, WidgetBuilder>{
        SplashScreen.routeName: (_) => const SplashScreen(),
        SignInScreen.routeName: (_) => const SignInScreen(),


      },

    );
  }
}
