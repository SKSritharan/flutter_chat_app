import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_chat_app/screens/home_screen.dart';
import 'package:flutter_chat_app/screens/signin_screen.dart';
import 'package:flutter_chat_app/screens/signup_screen.dart';
import 'package:flutter_chat_app/screens/splash_screen.dart';

import './utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      routes: {
        SignInScreen.routeName: (ctx) => const SignInScreen(),
        SignUpScreen.routeName: (ctx) => const SignUpScreen(),
        HomeScreen.routeName: (ctx) => const HomeScreen(),
      },
    );
  }
}
