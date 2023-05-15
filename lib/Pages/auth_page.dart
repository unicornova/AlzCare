import 'package:alzcare/Pages/auth_page2.dart';
import 'package:alzcare/Pages/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData)
          {
            return const VerifyEmailPage();
          }
          else
          {
            return const Auth2();
          }
        },
      ),
    );
  }
}