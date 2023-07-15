import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<List<String>> fetchContinents() async {
  const String query = r'''
    query GetContinents {
      continents {
        name
      }
    }
  ''';

  final HttpLink httpLink = HttpLink('https://countries.trevorblades.com/');
  final GraphQLClient client = GraphQLClient(link: httpLink, cache: GraphQLCache());

  final QueryOptions options = QueryOptions(document: gql(query));
  final QueryResult result = await client.query(options);

  if (result.hasException) {
    print('GraphQL Error: ${result.exception.toString()}');
    return []; // Return an empty list on error
  }

  final List<dynamic> continentData = result.data?['continents'];
  final List<String> continents = continentData.map((continent) => continent['name'] as String).toList();

  return continents;
}

  Future<void> saveContinentToFirebase(String continent) async {
    // Replace this with your Firebase code to save the selected continent
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    final DocumentSnapshot userDetailsSnapshot =
      await FirebaseFirestore.instance.collection('user details').doc(uid).get();

    if (uid != null) {
      if(userDetailsSnapshot.exists){
      await FirebaseFirestore.instance.collection('user details').doc(uid).update({
        'continent': continent,
      });
      }
      else{
        await FirebaseFirestore.instance.collection('user details').doc(uid).set({
        'continent': continent,
      });
      }
    }
  }


class Continents extends StatefulWidget {
  
  const Continents({super.key});

  @override
  State<Continents> createState() => _ContinentsState();
}

class _ContinentsState extends State<Continents> {

  String? selectedContinent;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchContinents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for data
          //return CircularProgressIndicator();
          //return const Center(child: CircularProgressIndicator());
          return Center(child: Container(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ));
                        
        } else if (snapshot.hasError) {
          // Display an error message if an error occurs
          return Text('Error: ${snapshot.error}');
        } else {
          // Build the dropdown menu with fetched continents
          final continents = snapshot.data ?? [];
          return Padding(
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
                  hint: const Text("Select Continent"),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  isDense: true,
                  isExpanded: true,
                  items: continents.map((continent) {
                    return DropdownMenuItem<String>(
                      value: continent,
                      child: Text(continent),
                    );
                  }).toList(),
                  value: selectedContinent,
                  onChanged: (value) {
                    // Handle dropdown value change
                    //print('Selected continent: $value');
                    setState(() {
                      selectedContinent = value;
                      saveContinentToFirebase(value!);
                    });
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
