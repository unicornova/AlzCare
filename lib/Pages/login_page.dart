import 'package:alzcare/components/button.dart';
import 'package:alzcare/components/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final secureStorage = FlutterSecureStorage();
  bool rememberMe = false;

  void signInUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (rememberMe) {
        await secureStorage.write(
          key: 'email',
          value: emailController.text,
        );
        await secureStorage.write(
          key: 'password',
          value: passwordController.text,
        );
      } else {
        await secureStorage.deleteAll();
      }

      if (userCredential.user != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          'lib\Pages\dashboard.dart', // Replace with your actual route name
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushReplacementNamed(context, 'lib\Pages\login_page.dart'); // Replace with your actual route name
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        wrongEmailMsg();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMsg();
      }
    }
  }

  void wrongEmailMsg() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(title: Text('Incorrect Email'));
      },
    );
  }

  void wrongPasswordMsg() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(title: Text('Incorrect Password'));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  void checkUserLoggedIn() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String? rememberMeValue = await secureStorage.read(key: 'rememberMe');
    bool shouldSignOut = rememberMeValue != 'true';

    if (user != null && shouldSignOut) {
      // If "Remember Me" is not checked, sign out the user
      await auth.signOut();
      user = null;
    }

    if (user != null) {
      // User is already logged in, navigate to the dashboard or home page
      Navigator.pushReplacementNamed(context, 'lib\Pages\dashboard.dart'); // Replace with your actual route name
    } else {
      // User is not logged in or signed out, navigate to the login page
      if (ModalRoute.of(context)?.settings.name != 'lib\Pages\login_page.dart') {
        Navigator.pushReplacementNamed(context, 'lib\Pages\login_page.dart'); // Replace with your actual route name
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 200, 199, 235),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                SvgPicture.asset(
                  'assets/brain.svg',
                  height: 90,
                ),
                const SizedBox(height: 25),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value ?? false;
                                secureStorage.write(key: 'rememberMe', value: rememberMe.toString());
                              });
                            },
                          ),
                          Text(
                            'Remember Me',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Button(
                  onTap: signInUser,
                ),
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.black12,
                        ),
                      ),
                      Text(
                        'Or Continue With',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.black12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/google.svg', height: 70),
                  ],
                ),
                const SizedBox(height: 45),
                GestureDetector(
                  onTap: widget.showRegisterPage,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New Here?',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Register!',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
