import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../components/textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key,required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

   String url = "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/countries%2Bstates%2Bcities.json";

  var _countries = [];
  var _states = [];
  var _cities = [];


  DateTime _dateTime= DateTime.now();

// these will be the values after selection of the item
  String? country;
  String? city;
  String? state;

// this will help to show the widget after 
  bool isCountrySelected = false;
  bool isStateSelected = false;

  //http get request to get data from the link
  Future getWorldData()async{
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
    var jsonResponse = convert.jsonDecode(response.body);

    setState(() {
      _countries = jsonResponse;
    });
      

      print(_countries);
    }
  }

  @override
  void initState() {

      getWorldData();
    
    super.initState();
  }


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

 void _showDatePicker()
 {
  showDatePicker(
    context: context,
    initialDate: DateTime.now(), 
    firstDate: DateTime(1600), 
    lastDate: DateTime(3000)
    ).then((value){
      setState(() {
        _dateTime=value!;
      });
    } );
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

          const SizedBox(height: 10),
          Text(
             //_dateTime.toString(),
             'Birthdate: '+DateFormat.yMMMEd().format(_dateTime),
             style: TextStyle(
               color: Colors.grey[800],
               fontSize: 15
             ),
             
            ),
           const SizedBox(height: 10),

           Container(
            width: 325,
            height: 45,
             child: MaterialButton(
              onPressed: (){
                _showDatePicker();
              },
               color: const Color.fromARGB(255, 203, 121, 218).withOpacity(0.5),
              child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Text('Choose Birthdate'),
              ),
             
             ),
           ),
          
           /*Padding(
             padding: const EdgeInsets.symmetric(horizontal: 30.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 Text(
                   'Forgot Password?',
                   style: TextStyle(color: Colors.grey[700]),),
               ],
             ),
           ),*/
          
           const SizedBox(height: 10),
          
          //Button(
           //onTap: signUpUser,
          //),

          if (_countries.isEmpty) const Center(child: CircularProgressIndicator()) else 
          Container(
            width: 332,
            height: 55,
            child: Card(
              color: Color.fromARGB(255, 218, 160, 228).withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButton<String>(
                underline: Container(),
                  hint: Text("Select Country"),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  isDense: true,
                  isExpanded: true,
                  items: _countries.map((ctry){
                  return DropdownMenuItem<String>(
                    value: ctry["name"],
                    child: Text(ctry["name"])
                    );
                }).toList(), 
                 value: country,
                onChanged: (value){
                    setState(() {
                     _states = [];
                     country = value!;
                     for(int i =0; i<_countries.length; i++){
                      if(_countries[i]["name"] == value){
                        _states = _countries[i]["states"];
                      }
                     }
                      isCountrySelected = true;
                    });
                }),
              ),
            ),
          ),
          const SizedBox(height: 5),
//======================================= State
          if(isCountrySelected)
            Container(
            width: 332,
            height: 55,
              child: Card(
                 color:  Color.fromARGB(255, 218, 160, 228).withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
              
                   padding: const EdgeInsets.all(10.0),
                  child: DropdownButton<String>(
                  underline: Container(),      
                  hint: Text("Select State"),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  isDense: true,
                  isExpanded: true,
                  items: _states.map((st){
                  return DropdownMenuItem<String>(
                    value: st["name"],
                    child: Text(st["name"])
                    );
                        }).toList(), 
                         value: state,
                        onChanged: (value){
                    setState(() {
                   
                     _cities = [];
                   state = value!;
                   for(int i =0; i<_states.length; i++){
                    if(_states[i]["name"] == value){
                      _cities = _states[i]["cities"];
                    }
                   }
                    isStateSelected = true;
                    });
                        }),
                ),
              ),
            ) else Container(),


        //=============================== City
/*if(isStateSelected)
            Card(
              color:  Colors.purple.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButton<String>(
                underline: Container(),
                hint: Text("Select City"),
                icon: const Icon(Icons.keyboard_arrow_down),
                isDense: true,
                isExpanded: true,
                items: _cities.map((ct){
                return DropdownMenuItem<String>(
                  value: ct["name"],
                  child: Text(ct["name"])
                  );
                      }).toList(), 
                       value: city,
                      onChanged: (value){
                  setState(() {
                 
                
                 city = value!;
              
                  });
                      }),
              ),
            ) 
            
            else Container(),*/

          
          const SizedBox(height: 10),
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
          
         // const SizedBox(height: 50),
          
          /*const Padding(
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
          
           ]),*/

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
  
