
import 'package:signum_beat/screen/home/navgation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../providers/auth/auth_provider.dart';
import '../home/home_screen.dart';
import 'signup.dart';

class AuthState extends StatelessWidget {
  const AuthState({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    return StreamBuilder<User?>(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final User? user = snapshot.data;
          if (user == null) {
            // User is not logged in
            return SignUp(); // Replace with your sign-in screen widget
          } else {
            // User is logged in
            return NavigationPage(); // Replace with your home screen widget
          }

        }
      },
    );
  }
}
