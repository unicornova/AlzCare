import 'package:alzcare/components/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String url =
      "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/countries%2Bstates%2Bcities.json";

  var _countries = [];
  var _states = [];
  var _cities = [];

  // These will be the values after selection of the item
  String? country;
  String? city;
  String? state;

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

      print(_countries);
    }
  }

  @override
  void initState() {
    getWorldData();
    super.initState();
  }

  final currentuser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  DateTime _dateTime = DateTime.now();

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

  Future<void> saveUserDetails() async {
    final uid = currentuser.uid;

    // Create a new document in the "user details" collection
    await FirebaseFirestore.instance.collection('user details').doc(uid).set({
      'username': textController.text,
      'birthdate': _dateTime,
      'country': country,
      'state': state,
      'city': city,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User details saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 216, 230),
      body: ListView(
        children: [
          const SizedBox(height: 35),
          const Icon(Icons.person, size: 72),
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
          Padding(
            padding: EdgeInsets.only(left: 33.0),
            child: Text(
              'Username',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          MyTextField(
            controller: textController,
            hintText: 'Type a username',
            obscureText: false,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 33.0),
            child: Text(
              'Birthdate: ' + DateFormat.yMMMEd().format(_dateTime),
              style: TextStyle(
                color: Colors.grey[800],
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
              color: const Color.fromARGB(255, 203, 121, 218).withOpacity(0.5),
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

          const SizedBox(height: 10),

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
            padding: const EdgeInsets.symmetric(horizontal: 120.0),
            child: MaterialButton(
              onPressed: saveUserDetails,
              color: Color.fromARGB(255, 140, 206, 142),
              child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Text('Save'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
