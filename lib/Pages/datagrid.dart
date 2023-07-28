import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Datagrid extends StatefulWidget {
  const Datagrid({super.key});

  @override
  State<Datagrid> createState() => _DatagridState();
}

class _DatagridState extends State<Datagrid> {
  late List<Users> _users;
  late UserDataSource _userDataSource;

   @override
  void initState() {
    super.initState();
    _loadUserData();
  }

   Future<List<Users>> _loadUserData() async {
    List<Users> users = await getUserData();
    return users;
  }


  signOutUser(){
    FirebaseAuth.instance.signOut();
  }

@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 145, 46, 165),
          actions: [
            IconButton(
              onPressed: signOutUser,
              icon: const Icon(Icons.logout),
            )
          ],
          title: const Text('DataGrid'),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        body: FutureBuilder<List<Users>>(
          future: _loadUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error loading user data'),
              );
            } else {
              _users = snapshot.data!;
              _userDataSource = UserDataSource(_users);
              return SfDataGrid(
                source: _userDataSource,
               
                selectionMode: SelectionMode.single,
                
                allowSorting: true,
                columns: [
                  GridColumn(
                    columnName: 'name',
                    label: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.center,
                        child: const Center(
                          child: Text(
                            'Name',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

 Future<List<Users>> getUserDataFromFirestore() async {
  List<Users> usersList = [];

  try {
    // Fetch the currently logged-in user
     QuerySnapshot<Map<String, dynamic>> userDetailsSnapshot =
        await FirebaseFirestore.instance.collection('user details').get();

    for (var userDetailsDoc in userDetailsSnapshot.docs) {
      String name = userDetailsDoc['name'];

    

      Users user = Users(name);
      usersList.add(user);
    }

    return usersList;
  } catch (e) {
    print('Error fetching user data: $e');
    return usersList;
  }
}


Future<List<Users>> getUserData() async{
  return await getUserDataFromFirestore();
}
}

class UserDataSource extends DataGridSource{



  

  UserDataSource (List<Users> users){
    dataGridRows = users.map<DataGridRow>((data) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'name', value: data.name),
      ]);
    }).toList();
  }
  late List<DataGridRow> dataGridRows;
  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row){
    return DataGridRowAdapter(cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(dataGridCell.value.toString()),);
    }).toList());
  }
}

 class Users{
  Users(this.name);
  late final String name;
}