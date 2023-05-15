//import 'dart:js';

//import 'dart:html';

import 'package:alzcare/components/button.dart';
import 'package:alzcare/components/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
   final VoidCallback showRegisterPage;
   const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

   void signInUser() async{
     showDialog
     (context: context, 
     builder: ((context) {
       return const Center(
        child: CircularProgressIndicator(),
       );
     }
     )
     );

     
     
     try{
     await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text);

      Navigator.pop(context);

     }on FirebaseAuthException catch(e){

      Navigator.pop(context);

      if(e.code =='user-not-found')
      {
        wrongEmailMsg();
      }
      else if(e.code== 'wrong-password')
      {
        wrongPasswordMsg();
      }
     }

      // ignore: use_build_context_synchronously
      
   }

   void wrongEmailMsg()
   {
     showDialog(
      context: context,
       builder: (context)
       {
        return const AlertDialog(title: Text('Incorrect Email'));
       }
     );
   }

   void wrongPasswordMsg()
   {
      showDialog(
      context: context,
       builder: (context)
       {
        return const AlertDialog(title: Text('Incorrect Password'));
       }
     );
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false ,
      resizeToAvoidBottomInset: false,
      //backgroundColor:const Color.fromARGB(255, 183, 182, 216),
      backgroundColor: const Color.fromARGB(255, 200, 199, 235),
      //backgroundColor: Colors.blueGrey[100],
      //backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
       child: SingleChildScrollView(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            const SizedBox(height: 10),
           //logo
           SvgPicture.asset(
             'assets/brain.svg',
             height: 90,
           ),
          
            const SizedBox(height: 25),
          
           Text(
             'Welcome Back!',
             style: TextStyle(
               color: Colors.grey[800],
               fontSize: 18
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
                 Text(
                   'Forgot Password?',
                   style: TextStyle(color: Colors.grey[700]),),
               ],
             ),
           ),
          
           const SizedBox(height: 20),
          
          Button(
           onTap: signInUser,
          ),
          
          const SizedBox(height: 50),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Expanded(
                  child: Divider(
                   thickness: 1.5,
                   color: Colors.black12,
                  ),
                ),
          
                const Text('Or Continue With',
                style: TextStyle(color: Colors.black54,fontSize: 16),),
          
                const Expanded(
                  child:  Divider(
                   thickness: 1.5,
                   color:  Colors.black12,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
          
          Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children:[
           SvgPicture.asset('assets/google.svg',height: 70)
          
           ]),

           const SizedBox(height: 45),

           GestureDetector(
            onTap: widget.showRegisterPage,
             child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('New Here?',
                style: TextStyle(fontWeight: FontWeight.w500),),
                SizedBox(width: 4),
                Text(
                  'Register!',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
                  )
              ],
             ),
           )
          
          
          
          
          
             
         ]),
       ),
        ),
      ),
    ); 
  }
}