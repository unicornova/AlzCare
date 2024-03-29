
import 'package:alzcare/Pages/first_detection.dart';
import 'package:alzcare/Pages/invoice.dart';
import 'package:alzcare/Pages/rating.dart';
import 'package:alzcare/Pages/user_profile.dart';
import 'package:alzcare/Pages/sass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'my_drawer_header.dart';

import 'dashboard.dart';
import 'know_alz.dart';

import 'map_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  var currentPage = DrawerSections.sass;
 
 

  signOutUser(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {

  var container;

    if (currentPage == DrawerSections.user_profile) {
      container = const UserProfile();
    } 
    else if (currentPage == DrawerSections.dashboard) {
      container =  DashboardPage();
    } else if (currentPage == DrawerSections.detect_alzheimer) {
      container = const FirstDetection();
    } else if (currentPage == DrawerSections.know_alzheimer) {
      container = KnowAlzPage();
    }else if (currentPage == DrawerSections.rating) {
      container = const RatingPage();
    }else if (currentPage == DrawerSections.map) {
      container = const MapPage();
    }else if (currentPage == DrawerSections.signout) {
      container = signOutUser();
    }
    else if(currentPage == DrawerSections.pdf){
      container = Pdf();
    }
    else if(currentPage == DrawerSections.sass){
      container = Sass();
    }

    return Scaffold(
      key: _scaffoldKey,
      
      /*appBar: AppBar(backgroundColor: Color.fromARGB(255, 145, 46, 165),title: Center(child: Text('Alzcare')),
        actions: [IconButton(onPressed: signOutUser, icon: const Icon(Icons.logout))]),*/

      body: container,

      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget MyDrawerList() {
    return Container(
        padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        children: [
          menuItem(1, "Dashboard", Icons.design_services,
              currentPage == DrawerSections.sass ? true : false),
          menuItem(2, "Profile", Icons.person_2,
              currentPage == DrawerSections.user_profile ? true : false),
          menuItem(3, "Home Page", Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(4, "Detect Alzheimer", Icons.search,
              currentPage == DrawerSections.detect_alzheimer ? true : false),
          menuItem(5, "Know Alzheimer", Icons.event,
              currentPage == DrawerSections.know_alzheimer ? true : false),
          menuItem(6, "Rate this App", Icons.star,
              currentPage == DrawerSections.know_alzheimer ? true : false),
          menuItem(7, "Map", Icons.map,
              currentPage == DrawerSections.map ? true : false),
          menuItem(8, "Invoice", Icons.pages, 
              currentPage == DrawerSections.pdf ? true : false),         
          menuItem(9, "Logout", Icons.logout,
              currentPage == DrawerSections.signout ? true : false),
          
          
        ],
      )
    );
    }

Widget menuItem(int id, String title, IconData icon, bool selected){
  return Material(
   color: selected ? Colors.grey[300] : Colors.transparent,
   child: InkWell(
    onTap: () {
      Navigator.pop(context);
          setState(() {
             if (id == 1) {
              currentPage = DrawerSections.sass;
            }
            else if (id == 2) {
              currentPage = DrawerSections.user_profile;}
            else if (id == 3) {
              currentPage = DrawerSections.dashboard;
            } else if (id == 4) {
              currentPage = DrawerSections.detect_alzheimer;
            } else if (id == 5) {
              currentPage = DrawerSections.know_alzheimer;
            }
            else if (id == 6) {
              currentPage = DrawerSections.rating;
            } else if (id == 7) {
              currentPage = DrawerSections.map;
            }
            else if(id == 8){
              currentPage = DrawerSections.pdf;
            }
            else if (id == 9) {
              currentPage = DrawerSections.signout;
            }
          },); 
          },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children:[
           Expanded(
            child: Icon(
              icon,
              size: 20,
              color: Colors.black,)
              ),
          Expanded(
            flex: 3,
            child: Text(
              title, 
              style: TextStyle(
                color: Colors.black,
                 fontSize: 16),
                    ),
          ),
        ],
      ),
      ),
   ),
  );
}
}

enum DrawerSections{
  // ignore: constant_identifier_names
  user_profile,
  dashboard,
  // ignore: constant_identifier_names
  detect_alzheimer,
  // ignore: constant_identifier_names
  know_alzheimer,
  rating,
  map,
  pdf,
  signout,
  sass
}