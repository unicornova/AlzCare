import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../components/textfield.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key,required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

 Future signUpUser() async{
  showDialog
     (context: context, 
     builder: ((context) {
       return const Center(
        child: CircularProgressIndicator(),
       );
     }
     )
     );


  if(passwordConfirmed())
  {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: emailController.text,
     password: passwordController.text);
     Navigator.pop(context);
  }
  else
  {
    showDialog(context: context, builder: ((context) {
      return const AlertDialog(title: Text("Password didn't match"));
    }));
    Navigator.pop(context);
  }
 }

 bool passwordConfirmed()
 {
  if(passwordController.text==confirmPasswordController.text)
  {
    return true;
  }
  else {return false;}
 }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      //resizeToAvoidBottomPadding: false ,
      resizeToAvoidBottomInset: false,
      backgroundColor:const Color.fromARGB(255, 200, 199, 235),
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
             'Welcome to AlzCare!',
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

           const SizedBox(height: 10),
          
           MyTextField(
             controller: confirmPasswordController,
             hintText: 'Confirm Password',
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
          
          //Button(
           //onTap: signUpUser,
          //),

          GestureDetector(
           onTap: signUpUser,
           child: Container(
           padding: const EdgeInsets.all(15),
           margin: const EdgeInsets.symmetric(horizontal: 30.0),
           decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(6)),
           child:  Center(child: Text('Sign Up',
           style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 16),
          )),
        ),
        ), 
          
          const SizedBox(height: 50),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Expanded(
                  child: Divider(
                   thickness: 1.5,
                   color: Colors.black12,
                  ),
                ),
          
                Text('Or Continue With',
                style: TextStyle(color: Colors.black54,fontSize: 16),),
          
                Expanded(
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

           const SizedBox(height: 35),

           GestureDetector(
            onTap: widget.showLoginPage,
             child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Already a member?',
                style: TextStyle(fontWeight: FontWeight.w500),),
                SizedBox(width: 4),
                Text(
                  'Login!',
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
  
