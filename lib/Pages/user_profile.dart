// ignore_for_file: unnecessary_null_comparison
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../components/graphql_cont.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  late String? _imageURL = null;

  String url =
      "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/countries%2Bstates%2Bcities.json";

  var _countries = [];
  var _states = [];
  var _cities = [];

  // These will be the values after selection of the item
  String? country;
  String? city;
  String? state;
  String? phoneNumber;

  // This will help to show the widget after selection
  bool isCountrySelected = false;
  bool isStateSelected = false;

  // HTTP get request to fetch data from the link
  Future getWorldData() async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      setState(() {
        _countries = jsonResponse;
      });

      //print(_countries);
    }
  }

  @override
  void initState() {
    getWorldData();

    // Load the profile image URL from Firebase Storage and display it in the CircleAvatar
      final uid = currentuser.uid;
      FirebaseStorage.instance
          .ref('profile_images/$uid.jpg')
          .getDownloadURL()
          .then((url) {
        setState(() {
          _imageFile = null;
          _imageURL = url;
        });
      }).catchError((error) {
        print('Error loading profile image: $error');
      });

    super.initState();
  }

  final currentuser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  final phoneNumberController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  bool isUsernameTaken = false;
  

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600),
      lastDate: DateTime(3000),
    ).then((value) {
      if (value != null) {
        setState(() {
          _dateTime = value;
        });
      }
    });
  }


  Future<void> updateUserDetails() async {
  final username = textController.text;
  final phoneNumber = phoneNumberController.text;

  setState(() {
    this.phoneNumber = phoneNumber;
  });

  final uid = currentuser.uid;

  // Upload the profile image to Firebase Storage if a new image is selected
  if (_imageFile != null) {
    var storageRef =
        FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
    var file = File(_imageFile!.path);
    await storageRef.putFile(file);

    // Get the download URL of the uploaded image
    var downloadURL = await storageRef.getDownloadURL();

    // Update the imageURL variable
    setState(() {
      _imageURL = downloadURL;
    });
  }

  // Update the document in the "user details" collection
  await FirebaseFirestore.instance.collection('user details').doc(uid).update({
    'username': username,
    'birthdate': _dateTime,
    'country': country,
    'state': state,
    'city': city,
    'phoneNumber': phoneNumber,
    'imageURL': _imageURL,
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('User details updated')),
  );
}


  Future<void> saveUserDetails() async {
  final username = textController.text;
  final phoneNumber = phoneNumberController.text;

  setState(() {
    this.phoneNumber = phoneNumber;
  });

  final uid = currentuser.uid;

  // Check if the user already exists
  final DocumentSnapshot userDetailsSnapshot =
      await FirebaseFirestore.instance.collection('user details').doc(uid).get();

  if (userDetailsSnapshot.exists) {
    // User already exists, call the update method
    await updateUserDetails();
  } else {
    // User does not exist, call the set method

    // Upload the profile image to Firebase Storage if selected
    if (_imageFile != null) {
      var storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
      var file = File(_imageFile!.path);
      await storageRef.putFile(file);

      // Get the download URL of the uploaded image
      var downloadURL = await storageRef.getDownloadURL();

      // Update the imageURL variable
      setState(() {
        _imageURL = downloadURL;
      });
    }

    // Create a new document in the "user details" collection
    await FirebaseFirestore.instance.collection('user details').doc(uid).set({
      'username': username,
      'birthdate': _dateTime,
      'country': country,
      'state': state,
      'city': city,
      'phoneNumber': phoneNumber,
      'imageURL': _imageURL,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User details saved')),
    );
  }
}


  Widget bottomsheet(){
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0
      ),
      child: Column(
        children: [
          const Text("Choose Profile Photo",
          style: TextStyle(fontSize: 20.0),),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ElevatedButton.icon(
              onPressed:(){takePhoto(ImageSource.camera);},
              icon: Icon(Icons.camera), 
              label: Text("Camera",)),
             const SizedBox(width: 15,),
            ElevatedButton.icon(
              onPressed: () {takePhoto(ImageSource.gallery);},
              icon: Icon(Icons.image), 
              label: Text("Gallery",))
          ],)
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async{
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 216, 230),
      body: ListView(
        children: [
          const SizedBox(height: 35),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 62.0,
                  backgroundImage: _imageFile == null
                        ? (_imageURL != null
                            ? NetworkImage(_imageURL!) // Display the profile image URL if available
                            : AssetImage('assets/person.png') as ImageProvider)
                        : FileImage(File(_imageFile!.path)),
                ),
                Positioned(
                  bottom: 20.0,
                  right: 20.0,
                  child: InkWell(
                    onTap: (){
                      showModalBottomSheet(context: context, builder: ((builder)=> bottomsheet()));
                    },
                    child: Icon(
                      Icons.add_photo_alternate_rounded,
                      color: Colors.amber[200],
                      size: 35,
                    ),
                  ))
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(currentuser.email!, textAlign: TextAlign.center),
          const SizedBox(height: 25),
          Text(
            'My Details',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),


          const Padding(
            padding: EdgeInsets.only(left: 33.0),
            child: Text(
              'Username',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),



         Padding(
           padding:  const EdgeInsets.symmetric(horizontal: 30.0),
           child: TextField(
           controller: textController,
           decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600)
                    ),
                    fillColor: Colors.blueGrey.shade100,
                    filled: true,
                    hintText: 'Type a username',
                    hintStyle: TextStyle(color: Colors.grey[600])
           ),
           onChanged: (value) async {
             final username = value.trim();
         
             // Check if the username is already taken
             final QuerySnapshot existingUsernames = await FirebaseFirestore.instance
                 .collection('user details')
                 .where('username', isEqualTo: username)
                 .limit(1)
                 .get();
         
             setState(() {
               isUsernameTaken = existingUsernames.docs.isNotEmpty;
             });
           },
         ),
         ),


      const SizedBox(height: 10),


         if (isUsernameTaken)
            const Padding(
              padding: EdgeInsets.only(left: 33.0),
              child: Text(
                'Username is already taken',
                style: TextStyle(color: Color.fromARGB(255, 206, 56, 45),fontWeight: FontWeight.bold),
              ),
            ),
          if(!isUsernameTaken&&textController.text.trim().isNotEmpty)
          const Padding(
              padding: EdgeInsets.only(left: 33.0),
              child: Text(
                'Username is available',
                style: TextStyle(color: Color.fromARGB(255, 5, 156, 37),fontWeight: FontWeight.bold),
              ),
            ),
          
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.only(left: 33.0),
            child: Text(
              'Birthdate: ' + DateFormat.yMMMEd().format(_dateTime),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: MaterialButton(
              onPressed: () {
                _showDatePicker();
              },
              //color: const Color.fromARGB(255, 203, 121, 218).withOpacity(0.5),
              color: Color.fromARGB(255, 218, 160, 228).withOpacity(0.5),
              child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Text('Choose Birthdate'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 33.0),
            child: Text(
              'Address',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 7),

          const Continents(),
          const SizedBox(height: 5),

           if (_countries.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27.0),
              child: Card(
                color: Color.fromARGB(255, 218, 160, 228).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButton<String>(
                    underline: Container(),
                    hint: const Text("Select Country"),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isDense: true,
                    isExpanded: true,
                    items: _countries.map((ctry) {
                      return DropdownMenuItem<String>(
                        value: ctry["name"],
                        child: Text(ctry["name"]),
                      );
                    }).toList(),
                    value: country,
                    onChanged: (value) {
                      setState(() {
                        _states = [];
                        country = value!;
                        state = null;
                        city = null;
                        isCountrySelected = true;
                        isStateSelected = false;
                        for (int i = 0; i < _countries.length; i++) {
                          if (_countries[i]["name"] == value) {
                            _states = _countries[i]["states"];
                          }
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          const SizedBox(height: 5),
          if (isCountrySelected)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27.0),
              child: Card(
                color: Color.fromARGB(255, 218, 160, 228).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButton<String>(
                    underline: Container(),
                    hint: const Text("Select State"),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isDense: true,
                    isExpanded: true,
                    items: _states.map((st) {
                      return DropdownMenuItem<String>(
                        value: st["name"],
                        child: Text(st["name"]),
                      );
                    }).toList(),
                    value: state,
                    onChanged: (value) {
                      setState(() {
                        _cities = [];
                        state = value!;
                        city = null;
                        isStateSelected = true;
                        for (int i = 0; i < _states.length; i++) {
                          if (_states[i]["name"] == value) {
                            _cities = _states[i]["cities"];
                          }
                        }
                      });
                    },
                  ),
                ),
              ),
            )
          else
            Container(),
          if (isStateSelected)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27.0),
              child: Card(
                color: Color.fromARGB(255, 218, 160, 228).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButton<String>(
                    underline: Container(),
                    hint: const Text("Select City"),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isDense: true,
                    isExpanded: true,
                    items: _cities.map((ct) {
                      return DropdownMenuItem<String>(
                        value: ct["name"],
                        child: Text(ct["name"]),
                      );
                    }).toList(),
                    value: city,
                    onChanged: (value) {
                      setState(() {
                        city = value!;
                      });
                    },
                  ),
                ),
              ),
            )
          else
            Container(),

             const SizedBox(height: 10),

           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 30.0),
             child: Form(
              key: _formKey,
               child: TextFormField(
                       controller:phoneNumberController, 
                       obscureText: false,
                       keyboardType: TextInputType.phone,
                       onChanged: (value) {
                         _formKey.currentState?.validate();
                       },
                       validator: (value) {
                         if(value!.isEmpty){
                          return '';
                         }
                         else if(!RegExp(r'^\+880\d{10}$').hasMatch(value))
                         {
                           return 'Please enter a valid Phone Number';
                         }
                         
                           return null;
                         
                       },
                       decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade600)
                      ),
                      fillColor: Colors.blueGrey.shade100,
                      filled: true,
                      hintText: 'Provide Phone Number (Optional)',
                      hintStyle: TextStyle(color: Colors.grey[600])
                    ),
                       ),
             ),
           ),

            const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120.0),
            child: MaterialButton(
              onPressed: isUsernameTaken ? null : () async {await saveUserDetails();},
              color: Color.fromARGB(255, 0, 0, 0),
              child: Padding(
                padding: EdgeInsets.all(14.0),
                child: Text('Save',style: TextStyle(color: Colors.blueGrey.shade100),),
              ),
            ),
          ),
           const SizedBox(height: 15),
        ],
      ),
    );
  }
}



//In this flutter code, the image disappears if the user changes page or closes the app. Modify the code so that the image is saved in firebase storage when user hits the save button and doesn't disappear upon closing the app.


