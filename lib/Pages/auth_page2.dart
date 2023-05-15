import 'package:alzcare/Pages/login_page.dart';
import 'package:alzcare/Pages/register_page.dart';
import 'package:flutter/material.dart';

class Auth2 extends StatefulWidget {
  const Auth2({super.key});

  @override
  State<Auth2> createState() => _Auth2State();
}

class _Auth2State extends State<Auth2> {

  void toggleScreens()
  {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  bool showLoginPage = true;
  @override
  Widget build(BuildContext context) {
    if(showLoginPage)
    {
      return LoginPage(showRegisterPage: toggleScreens);
    }
    else
    {
      return RegisterPage(showLoginPage: toggleScreens);
    }
  }
}