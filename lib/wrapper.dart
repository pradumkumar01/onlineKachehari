import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/LoginScreen/OnlineKachehariWelcome.dart';
import 'package:flutter_online_kachehari/screens/HomePage.dart';
import 'package:flutter_online_kachehari/screens/LoginScreen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // While waiting for the authentication state to change
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // If there's an error, show an error message
          if (snapshot.hasError) {
            return const Center(
              child:
                  Text("Error occurred while fetching authentication state."),
            );
          }

          // If user is not logged in (null), show LoginScreen
          if (snapshot.data == null) {
            return const OnlineKachehariLoginScreen();
          }

          // If user is logged in, show HomePage
          return const HomePage();
        },
      ),
    );
  }
}
