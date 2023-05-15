import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

import 'home_page.dart';
import 'package:alzcare/utils/snackbar.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified)
    {
      sendVerificationEmail();
    }

   timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
  }
  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified()async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() { 
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    },);
    if(isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async{
    try{
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();

    setState(() => canResendEmail= false);
    await Future.delayed(Duration(seconds: 5));
    setState(() => canResendEmail= true);

    }catch(e){
    showSnackBar(context,e.toString());
    }
  }
  

  @override
  Widget build(BuildContext context) => isEmailVerified
    ? const HomePage()
    :Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 160, 108, 170),
        title:  const Text('Verify Email'),
      ),
      body: Padding(
        padding:  const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Text('A verification email has been sent to your email address',
            style : TextStyle(fontSize: 22),
            textAlign: TextAlign.center,),
            const SizedBox(
              height: 24),
            ElevatedButton.icon(
               style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(const Size(500, 45)),
    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 177, 131, 185)), // Change the background color of the ElevatedButton
  ),
             // style:ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
            onPressed:  canResendEmail? sendVerificationEmail : null,
            icon : const Icon(Icons.email,size: 32),
            label: const Text('Resend Email', style: TextStyle(fontSize: 24,color: Colors.white))
            
            ),
            SizedBox(height: 8) ,
            TextButton(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
              child : Text('Cancel', style: TextStyle(fontSize: 24,color: Color.fromARGB(255, 121, 78, 196))),
              onPressed: () => FirebaseAuth.instance.signOut(),
            )

          ],
          ),
        )
    );
    
  }

